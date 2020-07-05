//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
//
import Domain
import UIBase
import Extensions
import PointFreeFunctions

protocol SearchUser_RouterProtocol: class {
    func dismissView()
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }  // PublishRelay model Events

    func presentUserDetails(vm: VM.UserDetails)
}

extension Router {
    class SearchUser_Router: BaseRouter, BaseRouterProtocol, SearchUser_RouterProtocol {
        
        private weak var baseView: V.SearchUser_View?
        // PublishRelay model Events
        private var rxPublishRelay_ShowDetails = PublishRelay<VM.UserDetails>()
        init(viewController: V.SearchUser_View) {
            super.init()
            baseView = viewController
            func generalDismiss() {
                baseView?.dismiss(animated: true)
            }
            rxPublishRelay_ShowDetails
                .asObservable()
                .map { vm -> V.UserDetails_View? in return self.controllerWith(vm: vm) }
                .ignoreNil()
                .log(whereAmI())
                .subscribe(onNext: { [weak self] in
                    $0.modalPresentationStyle = .overFullScreen
                    self?.baseView?.present($0, animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
            
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)
            
        }
    
        private func controllerWith(vm: VM.UserDetails) -> V.UserDetails_View? {
            guard let controller = AppDelegate.shared.container.resolve(V.UserDetails_View.self) else { return nil }
            controller.presenter.viewModel = vm
            return controller
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
        
        func presentUserDetails(vm: VM.UserDetails) {
            rxPublishRelay_ShowDetails.accept(vm)
        }
    }
}