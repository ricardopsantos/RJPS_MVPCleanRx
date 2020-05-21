//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Domain
import Domain_GitHub

/**
 * 1 - Declare : Presenter_Protocol & View_Protocol (RX WAY)
 */

protocol SearchUser_PresenterProtocol_Input { // From View to Presenter
    func searchUserWith(username: String)
}

protocol SearchUser_PresenterProtocol_Output { // From Presenter to View
    var users: Signal<[String]>! { get }
}

protocol SearchUser_ProtocolPresenter_IO: SearchUser_PresenterProtocol_Input, SearchUser_PresenterProtocol_Output {
    var input: SearchUser_PresenterProtocol_Input { get }
    var output: SearchUser_PresenterProtocol_Output { get }
}

/**
 * 1 - Declare : Presenter_Protocol & View_Protocol (IMPERATIVE WAY)
 */

protocol SearchUser_PresenterProtocol: class, SearchUser_ProtocolPresenter_IO {
    var generic: BasePresenterVMPProtocol? { get }           // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get }  // Mandatory in ALL Presenters
    var viewModel: VM.SearchUser? { get set }                // Mandatory in ALL Presenters
    var router: SearchUser_RouterProtocol! { get }           // Mandatory in ALL Presenters

    func searchUserWith(username: String)
}

protocol SearchUser_ViewProtocol: class {
    func viewDataToScreen(some: VM.SearchUser)
}

/**
 * 2 - Declare : Presenter
 */

extension Presenter {
    class SearchUser_Presenter: BasePresenterMVP {
        weak var generic: BasePresenterVMPProtocol?
        weak var genericView: BaseViewControllerMVPProtocol?
        weak var view: SearchUser_ViewProtocol!
        var viewModel: VM.SearchUser? { didSet { DevTools.Log.appCode(.vmChanged); viewModelChanged() } }
        var router: SearchUser_RouterProtocol!
        var useCase_1: GitHubAPIRelated_UseCaseProtocol!
        
        var input: SearchUser_PresenterProtocol_Input { return self }
        var output: SearchUser_PresenterProtocol_Output { return self }
        var users: Signal<[String]>!
        private var rxPublishRelay_userInfo    = PublishRelay<GitHub.UserResponseDto?>()
        private var rxPublishRelay_userFriends = PublishRelay<[GitHub.UserResponseDto]?>()
    }
}

/**
 * 3 - Implementation : Presenter Protocol
 */

extension P.SearchUser_Presenter: SearchUser_PresenterProtocol {
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

extension P.SearchUser_Presenter: BasePresenterVMPProtocol {
    func view_deinit() { }
    func loadView() { rxSetup() }
    func viewDidAppear() { }
    func viewDidLoad() { }
    func viewWillAppear() { if viewModel != nil { updateViewWith(vm: viewModel) } }
    
    func rxSetup() {
        Observable.zip(rxPublishRelay_userInfo, rxPublishRelay_userFriends, resultSelector: { return ($0, $1) })
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] in
                guard let self = self else { return }
                self.genericView?.setActivityState(false)
                guard $0 != nil && $1 != nil else {
                    self.genericView?.displayMessage(Messages.pleaseTryAgainLater.localised, type: .error)
                    return
                }
                let vm = VM.UserDetais(user: $0!, friends: $1!)
                self.router.presentUserDetails(vm: vm)
            })
            .disposed(by: disposeBag)
        
        rxPublishRelay_error.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.genericView?.setActivityState(false)
                self.genericView?.displayMessage(Messages.messageWith(error: $0), type: .error)
            })
            .disposed(by: disposeBag)
    }
}

/**
 * 5 - Presenter Private Stuff
 */

extension P.SearchUser_Presenter {
    
    private func viewModelChanged() {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm: VM.SearchUser?) {
        guard vm != nil else { DevTools.Log.appCode(.ignored); return }
        view.viewDataToScreen(some: vm!)
    }
    
    private func rxObservable_getUserInfo(for username: String) -> Observable<Bool?> {
        return Observable.create { [weak self] _ -> Disposable in
            if let self = self {
                self.useCase_1.getInfoOfUserWith(userName: username, canUseCache: true) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let some): self.rxPublishRelay_userInfo.accept(some)
                    case .failure(let error):
                        self.rxPublishRelay_userInfo.accept(nil)
                        self.rxPublishRelay_error.accept(error)
                    }
                }
            } else {
                DevTools.Log.appCode( .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable(nil, reachabilityService: reachabilityService)
    }
    
    private func rxObservable_getUserFriends(for username: String) -> Observable<Bool?> {
        return Observable.create { [weak self] _ -> Disposable in
            if let self = self {
                self.useCase_1.getFriendsOfUserWith(userName: username, canUseCache: true, completionHandler: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let some) : self.rxPublishRelay_userFriends.accept(some)
                    case .failure(let error):
                        self.rxPublishRelay_userFriends.accept(nil)
                        self.rxPublishRelay_error.accept(error)
                    }
                })
            } else {
                DevTools.Log.appCode( .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable(nil, reachabilityService: reachabilityService)
    }
    
}
