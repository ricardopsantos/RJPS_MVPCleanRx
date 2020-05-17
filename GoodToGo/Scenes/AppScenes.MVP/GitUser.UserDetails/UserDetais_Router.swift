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

protocol UserDetais_RouterProtocol: class {
    func dismissView()
}

extension Router {
    class UserDetais_Router: BaseRouter, BaseRouterProtocol, UserDetais_RouterProtocol {
        
        private weak var baseView: V.UserDetais_View?

        init(viewController: V.UserDetais_View) {
            super.init()
            baseView = viewController
            
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
    }
}
