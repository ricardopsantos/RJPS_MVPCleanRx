//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BlissDetails_RouterProtocol: class {
    func dismissView()                                          
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }  // PublishRelay model Events
}

extension Router {
    class BlissDetails_Router: GenericRouter, GenericRouter_Protocol, BlissDetails_RouterProtocol {
        
        private weak var baseView : V.BlissDetails_View?
        init(viewController: V.BlissDetails_View) {
            super.init()
            baseView = viewController
            
            func generalDismiss() {
                if let navigationController = baseView?.navigationController {
                    navigationController.popViewController(animated: true)
                }
                else {
                    baseView?.dismiss(animated: true)
                }
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
