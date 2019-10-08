//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BlissRoot_RouterProtocol: class {
    func dismissView()                                // Mandatory in all Routers
    var rxPublishRelay_dismissView : PublishRelay<Void> { get } // PublishRelay model Events

    func goToList(asNavigationController:Bool)
    func goToListWith(vm:VM.BlissQuestionsList_ViewModel?, asNavigationController:Bool)
}

extension Router {
    class BlissRoot_Router: GenericRouter, GenericRouter_Protocol, BlissRoot_RouterProtocol {
        
        private weak var baseView : V.BlissRoot_View?
        // PublishRelay model Events
        private var rxPublishRelay_ShowQuestionsList = PublishRelay<VM.BlissQuestionsList_ViewModel?>()
        init(viewController: V.BlissRoot_View) {
            super.init()
            baseView = viewController
            func generalDismiss() {
                baseView?.dismiss(animated: true)
            }
            
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)
            
            rxPublishRelay_ShowQuestionsList.asObservable()
                .map { vm -> UINavigationController? in return self.controllerWith(vm: vm) }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in
                    $0.modalPresentationStyle = .overFullScreen
                    self?.baseView?.present($0, animated: true, completion: { })
                })
                .disposed(by: disposeBag)
        }
        
        private func controllerWith(vm:VM.BlissQuestionsList_ViewModel?) -> UINavigationController? {
            guard let controller = AppDelegate.shared.container.resolve(V.BlissQuestionsList_View.self) else { return nil }
            if let vm = vm {
                controller.presenter.viewModel = vm
            }
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
        
        func goToListWith(vm: VM.BlissQuestionsList_ViewModel?, asNavigationController:Bool) {
            rxPublishRelay_ShowQuestionsList.accept(vm)
        }
        
        func goToList(asNavigationController:Bool) {
            goToListWith(vm: nil, asNavigationController:asNavigationController)
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
    }
}
