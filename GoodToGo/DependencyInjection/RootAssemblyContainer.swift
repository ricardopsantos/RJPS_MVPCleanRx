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

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

//
// MARK: - Protocols
//

struct RootAssemblyContainerProtocols {

    //
    // Repositories
    //
    static let networkClient                 = RJS_SimpleNetworkClientProtocol.self
    static let hotCacheRepository            = HotCacheRepositoryProtocol.self
    static let genericLocalStorageRepository = KeyValuesStorageRepositoryProtocol.self
    static let apiCacheRepository            = APICacheManagerProtocol.self   
    static let carTrack_NetWorkRepository    = CarTrackNetWorkRepositoryProtocol.self    // Web API: Requests Protocol
    static let galleryApp_NetWorkRepository  = GalleryAppNetWorkRepositoryProtocol.self  // Web API: Requests Protocol

    //
    // Use Cases
    //

    // CarTrack
    static let carTrackGenericAppBusinessUseCase = CarTrackGenericAppBusinessUseCaseProtocol.self
    static let carTrackAPIUseCase                = CarTrackWebAPIUseCaseProtocol.self

    // GalleryApp
    static let galleryAppGenericAppBusinessUseCase = GalleryAppGenericBusinessUseCaseProtocol.self
    static let galleryAppAPIUseCase                = GalleryAppWebAPIUseCaseProtocol.self
    static let galleryAppWorker                    = GalleryAppWorkerProtocol.self

}

//
// MARK: - Resolvers
//

public class CarTrackResolver {
    private init() { }
    public static var shared   = CarTrackResolver()
    public let api             = AppDelegate.shared.container.resolve(AppProtocols.carTrackAPIUseCase.self)
    public let genericBusiness = AppDelegate.shared.container.resolve(AppProtocols.carTrackGenericAppBusinessUseCase.self)
}

public class GalleryAppResolver {
    private init() { }
    public static var shared   = GalleryAppResolver()
    public let api             = AppDelegate.shared.container.resolve(AppProtocols.galleryAppAPIUseCase.self)
    public let genericBusiness = AppDelegate.shared.container.resolve(AppProtocols.galleryAppGenericAppBusinessUseCase.self)
    public let worker          = AppDelegate.shared.container.resolve(AppProtocols.galleryAppWorker.self)
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
        
        container.autoregister(AppProtocols.genericLocalStorageRepository,
                               initializer: RP.KeyValuesStorageRepository.init).inObjectScope(.container)

        container.autoregister(AppProtocols.apiCacheRepository,
                               initializer: RP.APICacheManager.init).inObjectScope(.container)

        //
        // GalleryApp
        //

        container.autoregister(AppProtocols.galleryApp_NetWorkRepository,
                               initializer: WebAPI.GalleryApp.NetWorkRepository.init).inObjectScope(.container)

        // use case
        container.register(AppProtocols.galleryAppGenericAppBusinessUseCase) { resolver in
            let uc = GalleryAppMiscBusinessUseCase()
            uc.genericLocalStorageRepository = resolver.resolve(AppProtocols.genericLocalStorageRepository)
            uc.hotCacheRepository            = resolver.resolve(AppProtocols.hotCacheRepository)
            return uc
        }

        // use case
        container.register(AppProtocols.galleryAppAPIUseCase) { resolver in
            let uc = GalleryAppWebAPIUseCase()
            uc.networkRepository              = resolver.resolve(AppProtocols.galleryApp_NetWorkRepository)
            uc.genericLocalStorageRepository  = resolver.resolve(AppProtocols.genericLocalStorageRepository)
            uc.hotCacheRepository             = resolver.resolve(AppProtocols.hotCacheRepository)
            return uc
        }

        // worker
        container.register(AppProtocols.galleryAppWorker) { resolver in
            let w = GalleryAppWorker()
            w.networkRepository = resolver.resolve(AppProtocols.galleryAppAPIUseCase)
            w.genericUseCase    = resolver.resolve(AppProtocols.galleryAppGenericAppBusinessUseCase)
            return w
        }

        //
        // CarTrack
        //

        container.autoregister(AppProtocols.carTrack_NetWorkRepository,
                               initializer: WebAPI.CarTrack.NetWorkRepository.init).inObjectScope(.container)

        container.register(AppProtocols.carTrackAPIUseCase) { resolver in
            let uc = CarTrackAPIUseCase()
            uc.networkRepository             = resolver.resolve(AppProtocols.carTrack_NetWorkRepository)
            uc.genericLocalStorageRepository = resolver.resolve(AppProtocols.genericLocalStorageRepository)
            uc.hotCacheRepository            = resolver.resolve(AppProtocols.hotCacheRepository)
            return uc
        }

        container.register(AppProtocols.carTrackGenericAppBusinessUseCase) { resolver in
            let uc = Core_CarTrack.CarTrackGenericAppBusinessUseCase()
            uc.genericLocalStorageRepository  = resolver.resolve(AppProtocols.genericLocalStorageRepository)
            uc.hotCacheRepository             = resolver.resolve(AppProtocols.hotCacheRepository)
            return uc
        }
    }
}
