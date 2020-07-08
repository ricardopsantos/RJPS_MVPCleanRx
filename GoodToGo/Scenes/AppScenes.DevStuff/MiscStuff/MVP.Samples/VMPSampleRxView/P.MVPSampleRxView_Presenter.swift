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
import Swinject
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Domain

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol MVPSampleRxView_PresenterProtocol: class {
    var generic: BasePresenterVMPProtocol? { get }             // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get }    // Mandatory in ALL Presenters
    var viewModel: VM.MVPSampleRxView_ViewModel? { get set }   // Mandatory in ALL Presenters
    var router: MVPSampleRxView_RouterProtocol! { get }        // Mandatory in ALL Presenters
    
    func userDidTryToLoginWith(user: String, password: String)
}

protocol MVPSampleRxView_ViewProtocol: class {
    func updateViewWith(message: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class MVPSampleRxView_Presenter: BasePresenterMVP {
        weak var generic: BasePresenterVMPProtocol?
        weak var genericView: BaseViewControllerMVPProtocol?
        weak var view: MVPSampleRxView_ViewProtocol!
        var viewModel: VM.MVPSampleRxView_ViewModel? { didSet { DevTools.Log.appCode(.vmChanged); viewModelChanged() } }
        var router: MVPSampleRxView_RouterProtocol!

        var sample_UseCase: Sample_UseCaseProtocol!
    
    }
}

//
// MARK: - Presenter Protocol
//

extension P.MVPSampleRxView_Presenter: MVPSampleRxView_PresenterProtocol {
    
    func userDidTryToLoginWith(user: String, password: String) {
        rxObservable_doAssynTask(user: user, password: password)
            .log("Subscription 1")
            .debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            .log("Subscription 2")
            .throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance)
            .log("Subscription 3")
            .subscribe(
                onNext: { [weak self] some in
                    self?.viewModel! = VM.MVPSampleRxView_ViewModel(someString: some)
                },
                onError: { [weak self] error in
                    self?.genericView?.displayMessage(Messages.pleaseTryAgainLater.localised, type: .error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func rxObservable_doAssynTask(user: String, password: String) -> Observable<String> {
        return Observable.create { [weak self] observer -> Disposable in
            DevTools.Log.message("Creating observable...")
            guard let self = self else { return Disposables.create() }
            self.sample_UseCase.operation1(canUseCache: true) { (result) in
                switch result {
                case .success(let some): observer.onNext("\(some)")
                case .failure(let error) : observer.onError(error)
                }
            }
            return Disposables.create()
            }//.retry(3)
            //.retryOnBecomesReachable("", reachabilityService: reachabilityService)
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.MVPSampleRxView_Presenter: BasePresenterVMPProtocol {
    func view_deinit() { }
    func loadView() { setupViewRx() }
    func viewDidAppear() { }
    func viewDidLoad() { }
    func viewWillAppear() { }
}

extension P.MVPSampleRxView_Presenter {
    
    func viewModelChanged() {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm: VM.MVPSampleRxView_ViewModel?) {
        guard viewModel != nil else { DevTools.Log.appCode(.ignored); return }
        view.updateViewWith(message: viewModel!.someString)
    }
    
    func setupViewRx() {
        
    }
}
