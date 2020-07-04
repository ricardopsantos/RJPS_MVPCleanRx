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

protocol MVPSampleTableView_RouterProtocol: class {
    func dismissView()
    var rxPublishRelay_dismissView: PublishRelay<Void> { get } // PublishRelay model Events
}

extension Router {
    class MVPSampleTableView_Router: BaseRouter, BaseRouterProtocol, MVPSampleTableView_RouterProtocol {

        private weak var baseView: V.MVPSampleTableView_View?
        init(viewController: V.MVPSampleTableView_View) {
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