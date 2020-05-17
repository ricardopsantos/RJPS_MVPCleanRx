//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import Domain

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

extension AssembyContainer {
    final class MVPSampleView_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {

            // Router
            let routerProtocol = MVPSampleView_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.MVPSampleView_View) in
                return R.MVPSampleView_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = MVPSampleView_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.MVPSampleView_View) in
                let presenter         = P.MVPSampleView_Presenter()
                presenter.view        = viewController
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.genericView = viewController 
                presenter.generic     = presenter
                presenter.sample_UseCase = r.resolve(AppProtocols.sample_UseCase)
                return presenter
            }
            
            // View
            container.register(V.MVPSampleView_View.self) { r in
                let controller = V.MVPSampleView_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}
