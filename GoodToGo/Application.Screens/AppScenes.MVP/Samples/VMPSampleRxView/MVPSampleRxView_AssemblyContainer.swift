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
    final class MVPSampleRxView_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {

            // Router
            let routerProtocol = MVPSampleRxView_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.MVPSampleRxView_View) in
                return R.MVPSampleRxView_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = MVPSampleRxView_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.MVPSampleRxView_View) in
                let presenter         = P.MVPSampleRxView_Presenter()
                presenter.view        = viewController
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.sample_UseCase = r.resolve(AppProtocols.sample_UseCase)
                return presenter
            }
            
            // View
            container.register(V.MVPSampleRxView_View.self) { r in
                let controller = V.MVPSampleRxView_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
            
        }
    }
}
