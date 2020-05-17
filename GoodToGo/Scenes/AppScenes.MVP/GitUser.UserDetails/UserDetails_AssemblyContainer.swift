//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import Domain

extension AssembyContainer {
    final class UserDetails_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {
         
            // Router
            let routerProtocol = UserDetais_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.UserDetais_View) in
                return R.UserDetais_Router(viewController: viewController)
            }
   
            // Presenter
            let presenterProtocol = UserDetais_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.UserDetais_View) in
                let presenter         = P.UserDetais_Presenter()
                presenter.view        = viewController
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.tableView   = presenter
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                return presenter
            }
       
            // View
            container.register(V.UserDetais_View.self) { r in
                let controller = V.UserDetais_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
        }
    }
}
