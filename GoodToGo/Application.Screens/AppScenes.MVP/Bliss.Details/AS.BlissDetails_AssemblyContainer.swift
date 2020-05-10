//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import AppDomain

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

extension AssembyContainer {
    final class BlissDetails_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {
            
            // Router
            let routerProtocol = BlissDetails_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.BlissDetails_View) in
                return R.BlissDetails_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = BlissDetails_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.BlissDetails_View) in
                let presenter         = P.BlissDetails_Presenter()
                presenter.view        = viewController
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.tableView   = presenter
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.blissQuestions_UseCase = r.resolve(AppProtocols.blissQuestions_UseCase)
                presenter.blissGeneric_UseCase   = r.resolve(AppProtocols.blissGenericAppBusiness_UseCase)
                return presenter
            }
    
            // View
            container.register(V.BlissDetails_View.self) { r in
                let controller = V.BlissDetails_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}
