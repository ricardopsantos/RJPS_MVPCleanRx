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
import Domain_GalleryApp
import Repositories
import Repositories_WebAPI
import Core
import Core_CarTrack
import Core_GalleryApp
import DevTools

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

//
// MARK: - Protocols
//

struct RootAssemblyContainerProtocols {

    //
    // Generic Repositories
    //
    static let networkClient                 = RJS_SimpleNetworkClientProtocol.self
    static let hotCacheRepository            = HotCacheRepositoryProtocol.self
    static let coldKeyValuesRepository       = KeyValuesStorageRepositoryProtocol.self
    static let apiCacheRepository            = APICacheManagerProtocol.self   

    //
    // Use Cases
    //

    // CarTrack
    static let carTrackAppWorker                 = CarTrackWorkerProtocol.self
    static let carTrackAPIUseCase                = CarTrackWebAPIUseCaseProtocol.self             // UseCase - WebAPI
    static let carTrackGenericAppBusinessUseCase = CarTrackGenericAppBusinessUseCaseProtocol.self // UseCase - Generic
    static let carTrack_NetWorkRepository        = CarTrackNetWorkRepositoryProtocol.self         // Repository - WebAPI

    // GalleryApp
    static let galleryAppWorker                    = GalleryAppWorkerProtocol.self
    static let galleryAppAPIUseCase                = GalleryAppWebAPIUseCaseProtocol.self           // UseCase - WebAPI
    static let galleryAppGenericAppBusinessUseCase = GalleryAppGenericBusinessUseCaseProtocol.self  // UseCase - Generic
    static let galleryApp_NetWorkRepository        = GalleryAppNetWorkRepositoryProtocol.self       // Repository - WebAPI

}

//
// MARK: - Resolvers
//

public class CarTrackResolver {
    private init() { }
    // public let api            = ApplicationAssembly.assembler.resolver.resolve(AppProtocols.carTrackAPIUseCase.self)
    //public let genericBusiness = ApplicationAssembly.assembler.resolver.resolve(AppProtocols.carTrackGenericAppBusinessUseCase.self)
    public static let worker     = ApplicationAssembly.assembler.resolver.resolve(AppProtocols.carTrackAppWorker.self)
}

public class GalleryAppResolver {
    private init() { }
    //public let api             = ApplicationAssembly.assembler.resolver.resolve(AppProtocols.galleryAppAPIUseCase.self)
    //public let genericBusiness = ApplicationAssembly.assembler.resolver.resolve(AppProtocols.galleryAppGenericAppBusinessUseCase.self)
    public static let worker     = ApplicationAssembly.assembler.resolver.resolve(AppProtocols.galleryAppWorker.self)
}

//
// MARK: - RootAssemblyContainer
//

final class RootAssemblyContainer: Assembly {

    func assemble(container: Container) {

        //
        // Base app repositories
        //
        
        container.autoregister(AppProtocols.hotCacheRepository,
                               initializer: RP.HotCacheRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.networkClient,
                               initializer: RJS_SimpleNetworkClient.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.coldKeyValuesRepository,
                               initializer: RP.KeyValuesStorageRepository.init).inObjectScope(.container)

        container.autoregister(AppProtocols.apiCacheRepository,
                               initializer: RP.APICacheManager.init).inObjectScope(.container)

        //
        // GalleryApp
        //

        if DevTools.isMockApp {
            container.autoregister(AppProtocols.galleryApp_NetWorkRepository,
                                   initializer: WebAPI.GalleryApp.NetWorkRepositoryMock.init).inObjectScope(.container)
        } else {
            container.autoregister(AppProtocols.galleryApp_NetWorkRepository,
                                   initializer: WebAPI.GalleryApp.NetWorkRepository.init).inObjectScope(.container)
        }

        // worker
        container.register(AppProtocols.galleryAppWorker) { resolver in
            let w = GalleryAppWorker()
            w.webAPIUSeCase  = resolver.resolve(AppProtocols.galleryAppAPIUseCase)
            w.genericUseCase = resolver.resolve(AppProtocols.galleryAppGenericAppBusinessUseCase)
            return w
        }

        // use case
        container.register(AppProtocols.galleryAppGenericAppBusinessUseCase) { resolver in
            let uc = GalleryAppMiscBusinessUseCase()
            uc.coldKeyValuesRepository = resolver.resolve(AppProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(AppProtocols.hotCacheRepository)
            return uc
        }

        // use case
        container.register(AppProtocols.galleryAppAPIUseCase) { resolver in
            let uc = GalleryAppWebAPIUseCase()
            uc.networkRepository       = resolver.resolve(AppProtocols.galleryApp_NetWorkRepository) // Client WebAPI
            uc.coldKeyValuesRepository = resolver.resolve(AppProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(AppProtocols.hotCacheRepository)
            uc.apiCache                = resolver.resolve(AppProtocols.apiCacheRepository)
            return uc
        }

        //
        // CarTrack
        //

        container.autoregister(AppProtocols.carTrack_NetWorkRepository,
                               initializer: WebAPI.CarTrack.NetWorkRepository.init).inObjectScope(.container)

        // worker
        container.register(AppProtocols.carTrackAppWorker) { resolver in
            let w = CarTrackWorker()
            w.webAPIUSeCase  = resolver.resolve(AppProtocols.carTrackAPIUseCase)
            w.genericUseCase  = resolver.resolve(AppProtocols.carTrackGenericAppBusinessUseCase)
            return w
        }

        container.register(AppProtocols.carTrackAPIUseCase) { resolver in
            let uc = CarTrackAPIUseCase()
            uc.networkRepository       = resolver.resolve(AppProtocols.carTrack_NetWorkRepository) 
            uc.coldKeyValuesRepository = resolver.resolve(AppProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(AppProtocols.hotCacheRepository)
            uc.apiCache                = resolver.resolve(AppProtocols.apiCacheRepository)
            return uc
        }

        container.register(AppProtocols.carTrackGenericAppBusinessUseCase) { resolver in
            let uc = Core_CarTrack.CarTrackGenericAppBusinessUseCase()
            uc.coldKeyValuesRepository  = resolver.resolve(AppProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository       = resolver.resolve(AppProtocols.hotCacheRepository)
            return uc
        }
    }
}
