//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib
import RxSwift
import RxCocoa

/**
 * 1 - Declare : Presenter_Protocol & View_Protocol
 */

protocol SearchUser_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol? { get }   // Mandatory in ALL Presenters
    var genericView : GenericView? { get }                 // Mandatory in ALL Presenters
    var viewModel   : VM.SearchUser? { get set }           // Mandatory in ALL Presenters
    var router      : SearchUser_RouterProtocol! { get }   // Mandatory in ALL Presenters

    func searchUser(user:String)
    var rxPublishRelay_dismissView: PublishRelay<Void> { get } // PublishRelay model Events
}

protocol SearchUser_ViewProtocol : class {
    func viewDataToScreen(some:VM.SearchUser)
}

/**
 * 2 - Declare : Presenter
 */

extension Presenter {
    class SearchUser_Presenter : GenericPresenter {
        weak var generic      : GenericPresenter_Protocol?
        weak var genericView  : GenericView?
        weak var view    : SearchUser_ViewProtocol!
        var viewModel    : VM.SearchUser? { didSet { AppLogs.DLog(code: .vmChanged); viewModelChanged() } }
        var router       : SearchUser_RouterProtocol!
        var useCase_1    : GitUser_UseCaseProtocol!
    }
}

/**
 * 3 - Implementation : Presenter Protocol
 */

extension P.SearchUser_Presenter : SearchUser_PresenterProtocol {

    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
    
    func searchUser(user: String) {
        guard user.trim.count > 0 else {
            return
        }
        assertExistsInternetConnection(sender: genericView) { [weak self] in
            guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
            var gUser    : E.GitHubUser?
            var gFriends : [E.GitHubUser] = []
            let sequence = SequenceBlock()
            
            let allCool = { return gUser != nil }
            
            sequence.before {
                strongSelf.genericView?.setActivityState(true)
                }.operation {
                    strongSelf.useCase_1.getInfoOfUserWith(userName: user, canUseCache: true) { result in
                        switch result {
                        case .success(let some):
                            gUser = some
                            break
                        case .failure(_):
                            let _ = 1
                            break
                        }
                        sequence.success() // Continue to next sequence, not mather the result.
                    }
                }.operation {
                    strongSelf.useCase_1.getFriendsOfUserWith(userName: user, canUseCache: true, completionHandler: { result in
                        switch result {
                        case .success(let some):
                            gFriends = some
                            break
                        case .failure(_):
                            let _ = 1
                            break
                        }
                        sequence.success()
                    })
                }.operation {
                    // Final check...
                    if(allCool()) { sequence.success() }
                    else { sequence.fail() }
            }.waitAll(onSuccess: { strongSelf.router.presentUserDetails(vm: VM.UserDetais(user: gUser!, friends: gFriends)) },
                      onError  : { strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error) }
            ).after { strongSelf.genericView?.setActivityState(false) }
        }
    }
}


/**
 * 4 - Implementation : GenericPresenter_Protocol Protocol
 */

extension P.SearchUser_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void { }
    func viewWillAppear() -> Void { if(viewModel != nil) { updateViewWith(vm: viewModel) } }
}

/**
 * 5 - Presenter Private Stuff
 */

extension P.SearchUser_Presenter {
    
    private func viewModelChanged() -> Void {
        updateViewWith(vm:viewModel)
    }
    
    private func updateViewWith(vm:VM.SearchUser?) -> Void {
        guard vm != nil else { AppLogs.DLog(code: .ignored); return }
        view.viewDataToScreen(some:vm!)
    }
}
