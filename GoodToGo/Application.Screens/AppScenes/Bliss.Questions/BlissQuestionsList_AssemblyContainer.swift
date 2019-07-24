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
    final class BlissQuestionsList_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {

            // Router
            let routerProtocol = BlissQuestionsList_RouterProtocol.self
            container.register(routerProtocol) { (r, viewController: V.BlissQuestionsList_View) in
                return R.BlissQuestionsList_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = BlissQuestionsList_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.BlissQuestionsList_View) in
                let presenter         = P.BlissQuestionsList_Presenter()
                presenter.view        = viewController
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.tableView   = presenter
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.blissQuestions_UseCase = r.resolve(AppProtocols.blissQuestions_UseCase)
                presenter.blissGeneric_UseCase   = r.resolve(AppProtocols.blissGenericAppBussiness_UseCase)
                return presenter
            }
    
            // View
            container.register(V.BlissQuestionsList_View.self) { r in
                let controller = V.BlissQuestionsList_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}

