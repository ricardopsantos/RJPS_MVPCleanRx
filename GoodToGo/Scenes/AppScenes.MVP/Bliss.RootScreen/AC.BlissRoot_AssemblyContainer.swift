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
    final class BlissRoot_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {
            
            // Router
            let routerProtocol = BlissRoot_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.BlissRoot_View) in
                return R.BlissRoot_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = BlissRoot_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.BlissRoot_View) in
                let presenter         = P.BlissRoot_Presenter()
                presenter.view        = viewController
                presenter.genericView = viewController 
                presenter.generic     = presenter
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.blissQuestions_UseCase = r.resolve(AppProtocols.blissQuestions_UseCase)
                presenter.blissGeneric_UseCase   = r.resolve(AppProtocols.blissGenericAppBusiness_UseCase)
                return presenter
            }
    
            // View
            container.register(V.BlissRoot_View.self) { r in
                let controller = V.BlissRoot_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}
