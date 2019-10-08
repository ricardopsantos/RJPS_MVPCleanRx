//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib
import RxCocoa
import RxSwift

protocol MVPSampleRxView_RouterProtocol: class {
    func dismissView()
    func presentControllerWith(vm:VM.MVPSampleRxView_ViewModel?)
}

extension Router {
    class MVPSampleRxView_Router: GenericRouter, GenericRouter_Protocol, MVPSampleRxView_RouterProtocol {
        
        // PublishRelay model Events
        var rxPublishRelay_showDetails = PublishRelay<VM.MVPSampleRxView_ViewModel?>()

        private weak var baseView : V.MVPSampleRxView_View?
        init(viewController: V.MVPSampleRxView_View) {
            super.init()
            baseView = viewController
            
            rxPublishRelay_showDetails.asObservable()
                .map { data -> UINavigationController? in
                    // Prepare controller
                    guard let controller = AppDelegate.shared.container.resolve(V.MVPSampleRxView_View.self) else { return nil }
                    if data != nil {
                        controller.presenter.viewModel = data
                    }
                    let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    return navigationController
                }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in
                    // Present / Show
                    $0.modalPresentationStyle = .overFullScreen
                    self?.baseView?.present($0, animated: true, completion: { })
                })
                .disposed(by: disposeBag)
            
            //
            // Dismiss : Option 1
            //
            rxPublishRelay_dismissView.asSignal()
                .debug("rxPublishRelay_dismissView.asSignal")
                .emit(onNext: { [weak self] _ in self?.generalDismiss() })
                .disposed(by: disposeBag)
            
            //
            // Dismiss : Option 2
            //
            rxPublishRelay_dismissView.asObservable()
                .debug("rxPublishRelay_dismissView.asObservable ")
                .subscribe(onNext: { [weak self] _ in self?.generalDismiss() })
                .disposed(by: disposeBag)
            
        }
        
        private func generalDismiss() {
            baseView?.dismiss(animated: true)
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
        
        func presentControllerWith(vm: VM.MVPSampleRxView_ViewModel?) {
            rxPublishRelay_showDetails.accept(vm)
        }
    }
}
