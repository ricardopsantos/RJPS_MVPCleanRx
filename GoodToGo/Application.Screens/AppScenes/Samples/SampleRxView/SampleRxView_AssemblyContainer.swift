//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

extension AssembyContainer {
    final class SampleRxView_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {

            // Router
            let routerProtocol = SampleRxView_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.SampleRxView_View) in
                return R.SampleRxView_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = SampleRxView_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.SampleRxView_View) in
                let presenter         = P.SampleRxView_Presenter()
                presenter.view        = viewController
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.sample_UseCase = r.resolve(AppProtocols.sample_UseCase)
                return presenter
            }
            
            // View
            container.register(V.SampleRxView_View.self) { r in
                let controller = V.SampleRxView_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
            
        }
    }
}
