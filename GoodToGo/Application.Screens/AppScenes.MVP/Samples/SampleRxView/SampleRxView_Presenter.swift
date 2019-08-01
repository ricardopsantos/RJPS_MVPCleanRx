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

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol SampleRxView_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol?   { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?                 { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.SampleRxView_ViewModel? { get set }
    var router      : SampleRxView_RouterProtocol! { get }     // Mandatory in ALL Presenters
    
    func userDidTryToLoginWith(user:String, password:String)
}

protocol SampleRxView_ViewProtocol: class {
    func updateViewWith(message: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class SampleRxView_Presenter : GenericPresenter {
        weak var generic      : GenericPresenter_Protocol?
        weak var genericView  : GenericView?
        weak var view   : SampleRxView_ViewProtocol!
        var viewModel   : VM.SampleRxView_ViewModel? { didSet { AppLogs.DLog(appCode: .vmChanged); viewModelChanged() } }
        var router      : SampleRxView_RouterProtocol!

        var sample_UseCase : Sample_UseCaseProtocol!
    
    }
}

//
// MARK: - Presenter Protocol
//

extension P.SampleRxView_Presenter : SampleRxView_PresenterProtocol {
    
    func userDidTryToLoginWith(user:String, password:String) {
        rxObservable_doAssynTask(user: user, password: password)
            .debug("Subscription 1")
            .debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            .debug("Subscription 2")
            .throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance)
            .debug("Subscription 3")
            .subscribe(
                onNext: { [weak self] some in
                    self?.viewModel! = VM.SampleRxView_ViewModel(someString: some)
                },
                onError: { [weak self] error in
                    self?.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func rxObservable_doAssynTask(user:String, password:String) -> Observable<String> {
        return Observable.create { [weak self] observer -> Disposable in
            AppLogs.DLog("Creating observable...")
            if let strongSelf = self {
                strongSelf.sample_UseCase.operation1(canUseCache: true) { (result) in
                    switch result {
                    case .success(let some): observer.onNext("\(some)")
                    case .failure(let error) : observer.onError(error)
                    }
                }
            } else {
                AppLogs.DLog(appCode: .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable("", reachabilityService: reachabilityService)
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.SampleRxView_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { setupPresenter() }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void { }
    func viewWillAppear() -> Void { }
}

extension P.SampleRxView_Presenter {
    
    private func viewModelChanged() -> Void {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm:VM.SampleRxView_ViewModel?) -> Void {
        guard viewModel != nil else { AppLogs.DLog(appCode: .ignored); return }
        view.updateViewWith(message: viewModel!.someString)
    }
    
    func setupPresenter() {
        
    }
}
