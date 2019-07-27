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

protocol SampleRxView_RouterProtocol: class {
    func dismissView()
    func presentControllerWith(vm:VM.SampleRxView_ViewModel?)
}

extension Router {
    class SampleRxView_Router: GenericRouter, GenericRouter_Protocol, SampleRxView_RouterProtocol {
        
        // PublishRelay model Events
        var rxPublishRelay_showDetails = PublishRelay<VM.SampleRxView_ViewModel?>()

        private weak var baseView : V.SampleRxView_View?
        init(viewController: V.SampleRxView_View) {
            super.init()
            baseView = viewController
            
            rxPublishRelay_showDetails.asObservable()
                .map { data -> UINavigationController? in
                    // Prepare controller
                    guard let controller = AppDelegate.shared.container.resolve(V.SampleRxView_View.self) else { return nil }
                    if(data != nil) {
                        controller.presenter.viewModel = data
                    }
                    let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    return navigationController
                }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in
                    // Present / Show
                    self?.baseView?.present($0, animated: true, completion: { })
                })
                .disposed(by: disposeBag)
        
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { [weak self] _ in
                    self?.baseView?.dismiss(animated: true)
                })
                .disposed(by: disposeBag)
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
        
        func presentControllerWith(vm: VM.SampleRxView_ViewModel?) {
            rxPublishRelay_showDetails.accept(vm)
        }
    }
}



