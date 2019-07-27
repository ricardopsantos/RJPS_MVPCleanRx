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
 * 1 - Declare : Presenter_Protocol & View_Protocol (RX WAY)
 */

protocol SearchUser_PresenterProtocol_Input { // From View to Presenter
    func searchUserWith(username:String)
}

protocol SearchUser_PresenterProtocol_Output { // From Presenter to View
    var users: Signal<[String]>! { get }
}

protocol SearchUser_ProtocolPresenter_IO: SearchUser_PresenterProtocol_Input, SearchUser_PresenterProtocol_Output {
    var input : SearchUser_PresenterProtocol_Input  { get }
    var output: SearchUser_PresenterProtocol_Output { get }
}

/**
 * 1 - Declare : Presenter_Protocol & View_Protocol (IMPERATIVE WAY)
 */

protocol SearchUser_PresenterProtocol : class, SearchUser_ProtocolPresenter_IO {
    var generic     : GenericPresenter_Protocol? { get }   // Mandatory in ALL Presenters
    var genericView : GenericView? { get }                 // Mandatory in ALL Presenters
    var viewModel   : VM.SearchUser? { get set }           // Mandatory in ALL Presenters
    var router      : SearchUser_RouterProtocol! { get }   // Mandatory in ALL Presenters

    func searchUserWith(username:String)
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
        weak var view         : SearchUser_ViewProtocol!
        var viewModel         : VM.SearchUser? { didSet { AppLogs.DLog(code: .vmChanged); viewModelChanged() } }
        var router            : SearchUser_RouterProtocol!
        var useCase_1         : GitUser_UseCaseProtocol!
        
        var input : SearchUser_PresenterProtocol_Input  { return self }
        var output: SearchUser_PresenterProtocol_Output { return self }
        var users : Signal<[String]>!
        private var _userInfo         = PublishRelay<E.GitHubUser?>()
        private var _userFriends     = PublishRelay<[E.GitHubUser]?>()
        private var _userDetailsSignal: Signal<VM.UserDetais>!
    }
}

/**
 * 3 - Implementation : Presenter Protocol
 */

extension P.SearchUser_Presenter : SearchUser_PresenterProtocol {
    func searchUserWith(username:String) {

    }
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
    
    /*
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
    }*/
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
    
    private func getUserInfo(for username: String) {
        useCase_1.getInfoOfUserWith(userName: username, canUseCache: true) { [weak self] result in
            guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
            switch result {
            case .success(let some): strongSelf._userInfo.accept(some)
            case .failure(_)       : strongSelf._userInfo.accept(nil)
            }
        }
    }
    
    private func getUserFriends(for username: String) {
        useCase_1.getFriendsOfUserWith(userName: username, canUseCache: true, completionHandler: { [weak self] result in
            guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
            switch result {
            case .success(let some): strongSelf._userFriends.accept(some)
            case .failure(_)       : strongSelf._userFriends.accept(nil)
            }
        })
    }
}
