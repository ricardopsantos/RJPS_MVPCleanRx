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
import Extensions
//
import Domain
import UIBase

extension Router {
    class UserDetails_Router: BaseRouter, BaseRouterProtocol, UserDetails_RouterProtocol {
        
        private weak var baseView: V.UserDetails_View?

        init(viewController: V.UserDetails_View) {
            super.init()
            baseView = viewController
            
            //
            // Dismiss : Option 1
            //
            rxPublishRelay_dismissView
                .asSignal()
                .emit(onNext: { [weak self] _ in self?.generalDismiss() })
                .disposed(by: disposeBag)
            
            //
            // Dismiss : Option 2
            //
            rxPublishRelay_dismissView.asObservable()
                .log("rxPublishRelay_dismissView.asObservable ")
                .subscribe(onNext: { [weak self] _ in self?.generalDismiss() })
                .disposed(by: disposeBag)
        }
        
        private func generalDismiss() {
            baseView?.dismiss(animated: true)
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
    }
}
