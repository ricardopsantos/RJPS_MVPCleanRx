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
    final class SampleView_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {

            // Router
            let routerProtocol = SampleView_RouterProtocol.self
            container.register(routerProtocol) { (r, viewController: V.SampleView_View) in
                return R.SampleView_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = SampleView_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.SampleView_View) in
                let presenter         = P.SampleView_Presenter()
                presenter.view        = viewController
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.sample_UseCase = r.resolve(AppProtocols.sample_UseCase)
                return presenter
            }
            
            // View
            container.register(V.SampleView_View.self) { r in
                let controller = V.SampleView_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}

