//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Swinject
import RJPSLib
//
import Domain
import API
import Repositories

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

struct RootAssemblyContainerProtocols {

    // Repositories
    static let networkClient                    = NetworkClient_Protocol.self
    static let generic_CacheRepository          = CacheRepositoryProtocol.self
    static let generic_LocalStorageRepository   = LocalStorageRepositoryProtocol.self
    static let bliss_NetWorkRepository          = Bliss_NetWorkRepositoryProtocol.self
    static let gitUser_NetWorkRepository        = GitUser_NetWorkRepositoryProtocol.self
    
    // Use Cases
    static let sample_UseCase                   = Sample_UseCaseProtocol.self
    static let sampleB_UseCase                  = SampleB_UseCaseProtocol.self
    static let blissQuestions_UseCase           = BlissQuestionsAPI_UseCaseProtocol.self
    static let blissGenericAppBusiness_UseCase  = BlissGenericAppBusiness_UseCaseProtocol.self
    static let gitUser_UseCase                  = GitUser_UseCaseProtocol.self
}

final class RootAssemblyContainer: Assembly {
    //
    // APENAS Instancias que precisamos no arranque
    //
    func assemble(container: Container) {
        
        container.autoregister(AppProtocols.generic_CacheRepository,
                               initializer: CacheRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.networkClient,
                               initializer: RJSLib.NetworkClient.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.generic_LocalStorageRepository,
                               initializer: LocalStorageRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.gitUser_NetWorkRepository,
                               initializer: WebAPI.GitUser.NetWorkRepository.init).inObjectScope(.container)

        container.autoregister(AppProtocols.bliss_NetWorkRepository,
                               initializer: WebAPI.Bliss.NetWorkRepository.init).inObjectScope(.container)
        
        container.register(AppProtocols.sample_UseCase) { resolver in
            let uc = Sample_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }
        
        container.register(AppProtocols.sampleB_UseCase) { resolver in
            let uc = SampleB_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }
        
        container.register(AppProtocols.gitUser_UseCase) { resolver in
            let uc = GitUser_UseCase()
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.gitUser_NetWorkRepository)
            return uc
        }
        
        container.register(AppProtocols.sample_UseCase) { resolver in
            let uc = Sample_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }
        
        container.register(AppProtocols.blissQuestions_UseCase) { resolver in
            let uc = BlissQuestionsAPI_UseCase()
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.bliss_NetWorkRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            return uc
        }
        
        container.register(AppProtocols.blissGenericAppBusiness_UseCase) { resolver in
            let uc = BlissGenericAppBusiness_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }
    
    }
}
