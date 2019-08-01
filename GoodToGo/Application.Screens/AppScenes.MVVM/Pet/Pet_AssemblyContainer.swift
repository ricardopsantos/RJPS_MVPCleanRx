//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject

extension AssembyContainer {
    final class Pet_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {
        
           /* // Router
            let routerProtocol = SearchUser_RouterProtocol.self
            container.register(routerProtocol) { (_, viewController: V.SearchUser_View) in
                return R.SearchUser_Router(viewController: viewController)
            }
            
            // Presenter
            let presenterProtocol = SearchUser_PresenterProtocol.self
            container.register(presenterProtocol) { (r, viewController: V.SearchUser_View) in
                let presenter         = P.SearchUser_Presenter()
                presenter.view        = viewController
                presenter.genericView = viewController
                presenter.generic     = presenter
                presenter.router      = r.resolve(routerProtocol, argument: viewController)
                presenter.useCase_1   = r.resolve(AppProtocols.gitUser_UseCase)
                return presenter
            }
            
            // View
            container.register(V.SearchUser_View.self) { r in
                let controller = V.SearchUser_View()
                controller.presenter = r.resolve(presenterProtocol, argument: controller)
                return controller
            }
            */
            
            // ViewModel (Presenter on MVP Pattern)
            let viewModelProtocol = Pet_ViewModelProtocol.self
            container.register(viewModelProtocol) { resolver in
                let viewModel           = VM.Pet_ViewModel()
                viewModel.sampleUseCase = resolver.resolve(AppProtocols.sample_UseCase)
                //dump(viewModel)
                //dump(viewModel.sampleUseCase)
                return viewModel
            }
            
            // View
            container.register(VC.Pet_ViewController.self) { resolver in
                let controller = VC.Pet_ViewController()
                controller.viewModel = resolver.resolve(viewModelProtocol)
                return controller
            }
        }
    }
}
