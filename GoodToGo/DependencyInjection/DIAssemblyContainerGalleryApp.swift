//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Swinject
import RJPSLib_Networking
//
import Domain
import Domain_GalleryApp
import Repositories
import Repositories_WebAPI
import Core
import Core_GalleryApp
import DevTools

//
// MARK: - Protocols references sugar
//

struct DIAssemblyContainerGalleryAppProtocols {
    static let galleryAppWorker                    = GalleryAppWorkerProtocol.self
    static let galleryAppAPIUseCase                = GalleryAppWebAPIUseCaseProtocol.self           // UseCase - WebAPI
    static let galleryAppGenericAppBusinessUseCase = GalleryAppGenericBusinessUseCaseProtocol.self  // UseCase - Generic
    static let galleryAppNetWorkRepository         = GalleryAppNetWorkRepositoryProtocol.self       // Repository - WebAPI
}

//
// MARK: - Resolvers
//

public class GalleryAppResolver {
    private init() { }
    public static let worker = DIAssemblerScenes.assembler.resolver.resolve(DIAssemblyContainerGalleryAppProtocols.galleryAppWorker.self)
}

//
// MARK: - Assembly Container
//

final class DIAssemblyContainerGalleryApp: Assembly {

    func assemble(container: Container) {
        //
        // GalleryApp
        //

        if DevTools.isMockApp {
            container.autoregister(DIAssemblyContainerGalleryAppProtocols.galleryAppNetWorkRepository,
                                   initializer: WebAPI.GalleryApp.NetWorkRepositoryMock.init).inObjectScope(.container)
        } else {
            container.autoregister(DIAssemblyContainerGalleryAppProtocols.galleryAppNetWorkRepository,
                                   initializer: WebAPI.GalleryApp.NetWorkRepository.init).inObjectScope(.container)
        }

        // worker
        container.register(DIAssemblyContainerGalleryAppProtocols.galleryAppWorker) { resolver in
            let w = GalleryAppWorker()
            w.webAPIUSeCase  = resolver.resolve(DIAssemblyContainerGalleryAppProtocols.galleryAppAPIUseCase)
            w.genericUseCase = resolver.resolve(DIAssemblyContainerGalleryAppProtocols.galleryAppGenericAppBusinessUseCase)
            return w
        }

        // use case
        container.register(DIAssemblyContainerGalleryAppProtocols.galleryAppGenericAppBusinessUseCase) { resolver in
            let uc = GalleryAppMiscBusinessUseCase()
            uc.coldKeyValuesRepository = resolver.resolve(DIRootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(DIRootAssemblyContainerProtocols.hotCacheRepository)
            return uc
        }

        // use case
        container.register(DIAssemblyContainerGalleryAppProtocols.galleryAppAPIUseCase) { resolver in
            let uc = GalleryAppWebAPIUseCase()
            uc.networkRepository       = resolver.resolve(DIAssemblyContainerGalleryAppProtocols.galleryAppNetWorkRepository) // Client WebAPI
            uc.coldKeyValuesRepository = resolver.resolve(DIRootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(DIRootAssemblyContainerProtocols.hotCacheRepository)
            uc.apiCache                = resolver.resolve(DIRootAssemblyContainerProtocols.apiCacheRepository)
            return uc
        }
    }

}
