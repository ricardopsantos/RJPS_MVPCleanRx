//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import RJPSLib

struct RootAssemblyContainerProtocols {
    // Repositories
    static let generic_LocalStorageRepository   = Generic_LocalStorageRepositoryProtocol.self
    static let bliss_NetWorkRepository          = Bliss_NetWorkRepositoryProtocol.self

    // Clients
    static let networkClient                    = NetworkClient_Protocol.self
    
    // Use Cases
    static let sample_UseCase                   = Sample_UseCaseProtocol.self
    static let sampleB_UseCase                  = SampleB_UseCaseProtocol.self
    static let blissQuestions_UseCase           = BlissQuestionsAPI_UseCaseProtocol.self
    static let blissGenericAppBussiness_UseCase = BlissGenericAppBussiness_UseCaseProtocol.self
    static let gitUser_UseCase                  = GitUser_UseCaseProtocol.self
}

final class RootAssemblyContainer: Assembly {
    //
    // APENAS Instancias que precisamos no arranque
    //
    func assemble(container: Container) {
        
        container.autoregister(AppProtocols.networkClient, initializer: RJSLib.NetworkClient.init).inObjectScope(.container)
        container.autoregister(AppProtocols.bliss_NetWorkRepository, initializer: RN.Bliss.NetWorkRepository.init).inObjectScope(.container)
        container.autoregister(AppProtocols.generic_LocalStorageRepository, initializer: RL.Generic_LocalStorageRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.sampleB_UseCase, initializer: UC.SampleB_UseCase.init).inObjectScope(.container)
        container.autoregister(AppProtocols.gitUser_UseCase, initializer: UC.GitUser_UseCase.init).inObjectScope(.container)
        container.autoregister(AppProtocols.blissQuestions_UseCase, initializer: UC.BlissQuestionsAPI_UseCase.init).inObjectScope(.container)
        container.autoregister(AppProtocols.blissGenericAppBussiness_UseCase, initializer: UC.BlissGenericAppBussiness_UseCase.init).inObjectScope(.container)

        container.register(AppProtocols.sample_UseCase) { resolver in
            let uc               = UC.Sample_UseCase()
            uc.generic_LocalStorageRepository = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            return uc
        }
        
        container.register(AppProtocols.blissQuestions_UseCase) { resolver in
            let uc               = UC.BlissQuestionsAPI_UseCase()
            uc.repositoryNetwork = resolver.resolve(AppProtocols.bliss_NetWorkRepository)
            return uc
        }
        
        container.register(AppProtocols.blissGenericAppBussiness_UseCase) { resolver in
            let uc               = UC.BlissGenericAppBussiness_UseCase()
            uc.generic_LocalStorageRepository = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            return uc
        }
    
    }
}
