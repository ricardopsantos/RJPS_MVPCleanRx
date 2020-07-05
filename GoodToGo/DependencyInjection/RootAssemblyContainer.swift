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
import Domain_Bliss
import Domain_CarTrack
import Domain_GitHub
import Repositories
import Repositories_WebAPI
import Core

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
    }
}
