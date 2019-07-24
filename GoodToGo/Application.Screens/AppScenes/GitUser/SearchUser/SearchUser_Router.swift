//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchUser_RouterProtocol: class {
    func dismissView()
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }  // PublishRelay model Events

    func presentUserDetails(vm:VM.UserDetais)
}

extension Router {
    class SearchUser_Router: GenericRouter, GenericRouter_Protocol, SearchUser_RouterProtocol {
        
        private weak var baseView : V.SearchUser_View?
        // PublishRelay model Events
        private var rxPublishRelay_ShowDetails = PublishRelay<VM.UserDetais>()
        init(viewController: V.SearchUser_View) {
            super.init()
            baseView = viewController
            func generalDismiss() {
                baseView?.dismiss(animated: true)
            }
            rxPublishRelay_ShowDetails.asObservable()
                .map { vm -> V.UserDetais_View? in return self.controllerWith(vm: vm) }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in self?.baseView?.present($0, animated: true, completion: nil) })
                .disposed(by: disposeBag)
            
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)
            
        }
    
        private func controllerWith(vm:VM.UserDetais) -> V.UserDetais_View? {
            guard let controller = AppDelegate.shared.container.resolve(V.UserDetais_View.self) else { return nil }
            controller.presenter.viewModel = vm
            return controller
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
        
        func presentUserDetails(vm:VM.UserDetais) {
            rxPublishRelay_ShowDetails.accept(vm)
        }
    }
}
