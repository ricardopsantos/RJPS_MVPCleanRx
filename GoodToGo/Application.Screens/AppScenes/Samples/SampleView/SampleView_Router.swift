//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib

protocol SampleView_RouterProtocol: class {
    func dismissView()
    func presentControllerWith(vm:VM.SampleView_ViewModel?)
}

extension Router {
    class SampleView_Router: GenericRouter, GenericRouter_Protocol, SampleView_RouterProtocol {

        private weak var baseView : V.SampleView_View?
        init(viewController: V.SampleView_View) {
            super.init()
            baseView = viewController
        }

        private func generalDismiss() {
            baseView?.dismiss(animated: true)
        }
        
        func dismissView() {
            generalDismiss()
        }
                
        func presentControllerWith(vm:VM.SampleView_ViewModel?) {
            guard let controller = AppDelegate.shared.container.resolve(V.SampleView_View.self) else { return }
            if vm != nil {
                controller.presenter.viewModel = vm
            }
            baseView?.present(controller, animated: true, completion: nil)
        }
        
    }
}

