//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Swinject
import RJPSLib
//
import Domain
import WebAPI
import Repositories
import AppCore

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

struct RootAssemblyContainerProtocols {

    //
    // Repositories
    //
    static let networkClient                      = RJSLibNetworkClient_Protocol.self
    static let generic_CacheRepository            = CacheRepositoryProtocol.self
    static let generic_LocalStorageRepository     = LocalStorageRepositoryProtocol.self
    static let bliss_NetWorkRepository            = Bliss_NetWorkRepositoryProtocol.self
    static let gitUser_NetWorkRepository          = GitUser_NetWorkRepositoryProtocol.self
    static let carTrack_NetWorkRepository         = CarTrack_NetWorkRepositoryProtocol.self

    //
    // Use Cases
    //

    static let someProtocolXXXX_UseCase           = SomeProtocolXXXX_UseCaseProtocol.self

    // Sample
    static let sample_UseCase                     = Sample_UseCaseProtocol.self
    static let sampleB_UseCase                    = SampleB_UseCaseProtocol.self
    static let gitUser_UseCase                    = GitUserUseCaseProtocol.self

    // Bliss
    static let blissQuestions_UseCase             = BlissQuestionsAPIUseCaseProtocol.self
    static let blissGenericAppBusiness_UseCase    = BlissGenericAppBusinessUseCaseProtocol.self

    // CarTrack
    static let carTrackGenericAppBusiness_UseCase = CarTrackGenericAppBusinessUseCaseProtocol.self
    static let carTrackAPI_UseCase                = CarTrackAPI_UseCaseProtocol.self

}

final class RootAssemblyContainer: Assembly {
    //
    // APENAS Instancias que precisamos no arranque
    //
    func assemble(container: Container) {

        container.autoregister(AppProtocols.generic_CacheRepository,
                               initializer: RP.CacheRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.networkClient,
                               initializer: RJSLib.NetworkClient.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.generic_LocalStorageRepository,
                               initializer: RP.LocalStorageRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.gitUser_NetWorkRepository,
                               initializer: API.GitUser.NetWorkRepository.init).inObjectScope(.container)

        container.autoregister(AppProtocols.bliss_NetWorkRepository,
                               initializer: API.Bliss.NetWorkRepository.init).inObjectScope(.container)

        container.autoregister(AppProtocols.carTrack_NetWorkRepository,
                               initializer: API.CarTrack.NetWorkRepository.init).inObjectScope(.container)

        //
        // CarTrack
        //

        container.register(AppProtocols.carTrackAPI_UseCase) { resolver in
            let uc = UC.CarTrackAPI_UseCase()
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.carTrack_NetWorkRepository)
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.carTrackGenericAppBusiness_UseCase) { resolver in
            let uc = UC.CarTrackGenericAppBusinessUseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        //
        // Sample (min)
        //

        container.register(AppProtocols.someProtocolXXXX_UseCase) { resolver in
            let uc = UC.SomeProtocolXXXX_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.sample_UseCase) { resolver in
            let uc = UC.Sample_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.sampleB_UseCase) { resolver in
            let uc = UC.SampleB_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        //
        // GitHub
        //

        container.register(AppProtocols.gitUser_UseCase) { resolver in
            let uc = UC.GitUser_UseCase()
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.gitUser_NetWorkRepository)
            return uc
        }

        //
        // Bliss
        //

        container.register(AppProtocols.blissQuestions_UseCase) { resolver in
            let uc = UC.BlissQuestionsAPI_UseCase()
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.bliss_NetWorkRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            return uc
        }
        
        container.register(AppProtocols.blissGenericAppBusiness_UseCase) { resolver in
            let uc = UC.BlissGenericAppBusiness_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }
    
    }
}
