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
    final class MVPSampleTableView_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {

            // Router
            let routerProtocol = MVPSampleTableView_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.MVPSampleTableView_View) in
                return R.MVPSampleTableView_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = MVPSampleTableView_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.MVPSampleTableView_View) in
                let presenter         = P.MVPSampleTableView_Presenter()
                presenter.view        = viewController
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.tableView   = presenter
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.sample_UseCase  = r.resolve(AppProtocols.sample_UseCase)
                presenter.sampleB_UseCase = r.resolve(AppProtocols.sampleB_UseCase)
                return presenter
            }
    
            // View
            container.register(V.MVPSampleTableView_View.self) { r in
                let controller = V.MVPSampleTableView_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}
