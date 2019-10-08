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
        var viewModel         : VM.SearchUser? { didSet { AppLogs.DLog(appCode: .vmChanged); viewModelChanged() } }
        var router            : SearchUser_RouterProtocol!
        var useCase_1         : GitUser_UseCaseProtocol!
        
        var input : SearchUser_PresenterProtocol_Input  { return self }
        var output: SearchUser_PresenterProtocol_Output { return self }
        var users : Signal<[String]>!
        private var _rxPublishRelay_userInfo    = PublishRelay<E.GitHubUser?>()
        private var _rxPublishRelay_userFriends = PublishRelay<[E.GitHubUser]?>()
    }
}

/**
 * 3 - Implementation : Presenter Protocol
 */

extension P.SearchUser_Presenter : SearchUser_PresenterProtocol {
    func searchUserWith(username: String) {
        guard username.trim.count > 0 else { return }
        genericView?.setActivityState(true)
        rxObservable_getUserInfo(for: username.trim).subscribe().disposed(by: disposeBag)
        rxObservable_getUserFriends(for: username.trim).subscribe().disposed(by: disposeBag)
    }
}

/**
 * 4 - Implementation : GenericPresenter_Protocol Protocol
 */

extension P.SearchUser_Presenter : GenericPresenter_Protocol {
    func view_deinit() { }
    func loadView() { rxSetup() }
    func viewDidAppear() { }
    func viewDidLoad() { }
    func viewWillAppear() { if viewModel != nil { updateViewWith(vm: viewModel) } }
    
    func rxSetup() -> Void {
        Observable.zip(_rxPublishRelay_userInfo, _rxPublishRelay_userFriends, resultSelector: { return ($0, $1) })
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.genericView?.setActivityState(false)
                guard $0 != nil && $1 != nil else {
                    self?.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                    return
                }
                let vm = VM.UserDetais(user: $0!, friends: $1!)
                strongSelf.router.presentUserDetails(vm: vm)
            })
            .disposed(by: disposeBag)
        
        rxPublishRelay_error.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.genericView?.setActivityState(false)
                let localizableMessageForView = ($0 as NSError).localizableMessageForView
                strongSelf.genericView?.displayMessage(localizableMessageForView, type: .error)
            })
            .disposed(by: disposeBag)
    }
}

/**
 * 5 - Presenter Private Stuff
 */

extension P.SearchUser_Presenter {
    
    private func viewModelChanged() -> Void {
        updateViewWith(vm:viewModel)
    }
    
    private func updateViewWith(vm:VM.SearchUser?) -> Void {
        guard vm != nil else { AppLogs.DLog(appCode: .ignored); return }
        view.viewDataToScreen(some:vm!)
    }
    
    private func rxObservable_getUserInfo(for username: String) -> Observable<Bool?> {
        return Observable.create { [weak self] _ -> Disposable in
            if let strongSelf = self {
                strongSelf.useCase_1.getInfoOfUserWith(userName: username, canUseCache: true) { [weak self] result in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    switch result {
                    case .success(let some): strongSelf._rxPublishRelay_userInfo.accept(some)
                    case .failure(let error):
                        strongSelf._rxPublishRelay_userInfo.accept(nil)
                        strongSelf.rxPublishRelay_error.accept(error)
                    }
                }
            } else {
                AppLogs.DLog(appCode: .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable(nil, reachabilityService: reachabilityService)
    }
    
    private func rxObservable_getUserFriends(for username: String) -> Observable<Bool?> {
        return Observable.create { [weak self] _ -> Disposable in
            if let strongSelf = self {
                strongSelf.useCase_1.getFriendsOfUserWith(userName: username, canUseCache: true, completionHandler: { [weak self] result in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    switch result {
                    case .success(let some) : strongSelf._rxPublishRelay_userFriends.accept(some)
                    case .failure(let error):
                        strongSelf._rxPublishRelay_userFriends.accept(nil)
                        strongSelf.rxPublishRelay_error.accept(error)
                    }
                })
            } else {
                AppLogs.DLog(appCode: .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable(nil, reachabilityService: reachabilityService)
    }
    
}
