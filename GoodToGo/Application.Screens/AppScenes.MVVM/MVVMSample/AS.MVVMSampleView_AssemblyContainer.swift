//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject

extension AssembyContainer {
    final class MVVMSampleView_AssemblyContainer: Assembly {
        
        func assemble(container: Container) {
            
            // ViewModel (Presenter on MVP Pattern)
            let viewModelProtocol = MVVMSampleView_ViewModelProtocol.self
            container.register(viewModelProtocol) { resolver in
                let viewModel           = VM.MVVMSampleView_ViewModel()
                viewModel.sampleUseCase = resolver.resolve(AppProtocols.sample_UseCase)!
                return viewModel
            }
            
            // View
            container.register(VC.MVVMSampleView_ViewController.self) { resolver in
                let controller       = VC.MVVMSampleView_ViewController()
                controller.viewModel = resolver.resolve(viewModelProtocol)
                return controller
            }
        }
    }
}
