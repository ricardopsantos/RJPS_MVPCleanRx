//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

protocol UserDetais_RouterProtocol: class {
    func dismissView()
    var rxPublishRelay_dismissView: PublishRelay<Void> { get } // PublishRelay model Events
}

extension Router {
    class UserDetais_Router: GenericRouter, GenericRouter_Protocol, UserDetais_RouterProtocol {
        
        fileprivate weak var baseView : V.UserDetais_View?

        init(viewController: V.UserDetais_View) {
            super.init()
            baseView = viewController
            func generalDismiss() {
                baseView?.dismiss(animated: true)
            }
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)
        }
        
        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
        
    }
}

