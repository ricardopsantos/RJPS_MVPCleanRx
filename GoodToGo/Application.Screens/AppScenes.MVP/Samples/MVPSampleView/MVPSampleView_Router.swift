//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
//
import AppDomain
import UIBase

protocol MVPSampleView_RouterProtocol: class {
    func dismissView()
    func presentControllerWith(vm: VM.MVPSampleView_ViewModel?)
}

extension Router {
    class MVPSampleView_Router: BaseRouter, BaseRouterProtocol, MVPSampleView_RouterProtocol {

        private weak var baseView: V.MVPSampleView_View?
        init(viewController: V.MVPSampleView_View) {
            super.init()
            baseView = viewController
        }

        private func generalDismiss() {
            baseView?.dismiss(animated: true)
        }
        
        func dismissView() {
            generalDismiss()
        }
                
        func presentControllerWith(vm: VM.MVPSampleView_ViewModel?) {
            guard let controller = AppDelegate.shared.container.resolve(V.MVPSampleView_View.self) else { return }
            if vm != nil {
                controller.presenter.viewModel = vm
            }
            controller.modalPresentationStyle = .overFullScreen
            baseView?.present(controller, animated: true, completion: nil)
        }
        
    }
}
