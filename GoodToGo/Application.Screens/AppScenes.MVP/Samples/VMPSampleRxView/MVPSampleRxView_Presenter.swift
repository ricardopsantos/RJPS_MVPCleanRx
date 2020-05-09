//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
import AppDomain

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol MVPSampleRxView_PresenterProtocol: class {
    var generic: GenericPresenter_Protocol? { get }          // Mandatory in ALL Presenters
    var genericView: GenericViewProtocol? { get }                    // Mandatory in ALL Presenters
    var viewModel: VM.MVPSampleRxView_ViewModel? { get set }
    var router: MVPSampleRxView_RouterProtocol! { get }       // Mandatory in ALL Presenters
    
    func userDidTryToLoginWith(user: String, password: String)
}

protocol MVPSampleRxView_ViewProtocol: class {
    func updateViewWith(message: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class MVPSampleRxView_Presenter: GenericPresenter {
        weak var generic: GenericPresenter_Protocol?
        weak var genericView: GenericViewProtocol?
        weak var view: MVPSampleRxView_ViewProtocol!
        var viewModel: VM.MVPSampleRxView_ViewModel? { didSet { AppLogger.log(appCode: .vmChanged); viewModelChanged() } }
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
            .debug("Subscription 1")
            .debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            .debug("Subscription 2")
            .throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance)
            .debug("Subscription 3")
            .subscribe(
                onNext: { [weak self] some in
                    self?.viewModel! = VM.MVPSampleRxView_ViewModel(someString: some)
                },
                onError: { [weak self] error in
                    self?.genericView?.displayMessage(AppMessages.pleaseTryAgainLater.localised, type: .error, asAlert: false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func rxObservable_doAssynTask(user: String, password: String) -> Observable<String> {
        return Observable.create { [weak self] observer -> Disposable in
            AppLogger.log("Creating observable...")
            if let self = self {
                self.sample_UseCase.operation1(canUseCache: true) { (result) in
                    switch result {
                    case .success(let some): observer.onNext("\(some)")
                    case .failure(let error) : observer.onError(error)
                    }
                }
            } else {
                AppLogger.log(appCode: .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable("", reachabilityService: reachabilityService)
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.MVPSampleRxView_Presenter: GenericPresenter_Protocol {
    func view_deinit() { }
    func loadView() { rxSetup() }
    func viewDidAppear() { }
    func viewDidLoad() { }
    func viewWillAppear() { }
}

extension P.MVPSampleRxView_Presenter {
    
    private func viewModelChanged() {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm: VM.MVPSampleRxView_ViewModel?) {
        guard viewModel != nil else { AppLogger.log(appCode: .ignored); return }
        view.updateViewWith(message: viewModel!.someString)
    }
    
    func rxSetup() {
        
    }
}
