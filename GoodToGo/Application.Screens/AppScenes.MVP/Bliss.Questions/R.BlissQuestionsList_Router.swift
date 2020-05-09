//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BlissQuestionsList_RouterProtocol: class {
    func dismissView()
    var rxPublishRelay_dismissView: PublishRelay<Void> { get } // PublishRelay model Events

    func goToDetails(vm: VM.BlissDetails_ViewModel)
    func goToDetails()
}

extension Router {
    class BlissQuestionsList_Router: GenericRouter, GenericRouter_Protocol, BlissQuestionsList_RouterProtocol {

        private weak var baseView: V.BlissQuestionsList_View?
        // PublishRelay model Events
        private var rxPublishRelay_ShowDetails = PublishRelay<VM.BlissDetails_ViewModel?>()
        init(viewController: V.BlissQuestionsList_View) {
            super.init()
            baseView = viewController
            func generalDismiss() {
                baseView?.dismiss(animated: true)
            }
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)
            rxPublishRelay_ShowDetails.asObservable()
                .map { vm -> V.BlissDetails_View? in return self.controllerWith(vm: vm) }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in
                    if let navigationController = self?.baseView?.navigationController {
                        navigationController.pushViewController($0, animated: true)
                    } else {
                        $0.modalPresentationStyle = .overFullScreen
                        self?.baseView?.present($0, animated: true, completion: { })
                    }
                })
                .disposed(by: disposeBag)
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
        
        private func controllerWith(vm: VM.BlissDetails_ViewModel?) -> V.BlissDetails_View? {
            guard let controller = AppDelegate.shared.container.resolve(V.BlissDetails_View.self) else { return nil }
            if vm != nil {
                controller.presenter.viewModel = vm
            }
            return controller
        }
        
        func goToDetails(vm: VM.BlissDetails_ViewModel) {
            rxPublishRelay_ShowDetails.accept(vm)
        }
        
        func goToDetails() {
            rxPublishRelay_ShowDetails.accept(nil)
        }
    }
}
