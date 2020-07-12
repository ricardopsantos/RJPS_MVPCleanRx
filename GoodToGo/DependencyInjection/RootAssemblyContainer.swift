//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Swinject
import RJPSLib_Networking
//
import Domain
import Domain_CarTrack
import Domain_GitHub
import Repositories
import Repositories_WebAPI
import Core
import Core_CarTrack
import Core_GitHub

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

//
// MARK: - Protocols
//

struct RootAssemblyContainerProtocols {

    //
    // Repositories
    //
    static let networkClient                      = RJSLibNetworkClient_Protocol.self
    static let generic_CacheRepository            = SimpleCacheRepositoryProtocol.self
    static let generic_LocalStorageRepository     = KeyValuesStorageRepositoryProtocol.self
    static let gitUser_NetWorkRepository          = GitUser_NetWorkRepositoryProtocol.self
    static let carTrack_NetWorkRepository         = CarTrack_NetWorkRepositoryProtocol.self

    //
    // Use Cases
    //

    static let someProtocolXXXX_UseCase           = SomeProtocolXXXX_UseCaseProtocol.self

    // Sample
    static let sample_UseCase                     = Sample_UseCaseProtocol.self
    static let sampleB_UseCase                    = SampleB_UseCaseProtocol.self
    static let gitUser_UseCase                    = GitHubAPIRelated_UseCaseProtocol.self
    
    // CarTrack
    static let carTrackGenericAppBusiness_UseCase = CarTrackGenericAppBusiness_UseCaseProtocol.self
    static let carTrackAPI_UseCase                = CarTrackAPIRelated_UseCaseProtocol.self

}

//
// MARK: - Resolvers
//

public class CarTrackResolver {
    private init() { }
    public static var shared   = CarTrackResolver()
    public let api             = AppDelegate.shared.container.resolve(AppProtocols.carTrackAPI_UseCase.self)
    public let genericBusiness = AppDelegate.shared.container.resolve(AppProtocols.carTrackGenericAppBusiness_UseCase.self)
}

//
// MARK: - RootAssemblyContainer
//

final class RootAssemblyContainer: Assembly {

    func assemble(container: Container) {

        //
        // Base app repositories
        //
        
        container.autoregister(AppProtocols.generic_CacheRepository,
                               initializer: RP.SimpleCacheRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.networkClient,
                               initializer: RJSLib.NetworkClient.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.generic_LocalStorageRepository,
                               initializer: RP.KeyValuesStorageRepository.init).inObjectScope(.container)

        //
        // CarTrack
        //

        container.autoregister(AppProtocols.carTrack_NetWorkRepository,
                               initializer: API.CarTrack.NetWorkRepository.init).inObjectScope(.container)

        container.register(AppProtocols.carTrackAPI_UseCase) { resolver in
            let uc = CarTrackAPI_UseCase()
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.carTrack_NetWorkRepository)
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.carTrackGenericAppBusiness_UseCase) { resolver in
            let uc = Core_CarTrack.CarTrackGenericAppBusinessUseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        //
        // Sample (min)
        //

        container.register(AppProtocols.someProtocolXXXX_UseCase) { resolver in
            let uc = SomeProtocolXXXX_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

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

        //
        // GitHub
        //

        container.autoregister(AppProtocols.gitUser_NetWorkRepository,
                               initializer: API.GitUser.NetWorkRepository.init).inObjectScope(.container)

        container.register(AppProtocols.gitUser_UseCase) { resolver in
            let uc = GitUser_UseCase()
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.gitUser_NetWorkRepository)
            return uc
        }

    }
}
