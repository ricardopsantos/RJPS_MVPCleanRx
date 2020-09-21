//
//  GoodToGo
//
//  Created by Ricardo Santos on 21/09/2020.
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
// MARK: - GalleryAppResolver
//

public class GalleryAppResolver {
    private init() { }
    public static let worker = ApplicationAssembly.assembler.resolver.resolve(RootAssemblyContainerProtocols.galleryAppWorker.self)
}

//
// MARK: - ManagersAssemblyContainer
//

final class GalleryAppAssemblyContainer: Assembly {

    func assemble(container: Container) {
        //
        // GalleryApp
        //

        if DevTools.isMockApp {
            container.autoregister(RootAssemblyContainerProtocols.galleryAppNetWorkRepository,
                                   initializer: WebAPI.GalleryApp.NetWorkRepositoryMock.init).inObjectScope(.container)
        } else {
            container.autoregister(RootAssemblyContainerProtocols.galleryAppNetWorkRepository,
                                   initializer: WebAPI.GalleryApp.NetWorkRepository.init).inObjectScope(.container)
        }

        // worker
        container.register(RootAssemblyContainerProtocols.galleryAppWorker) { resolver in
            let w = GalleryAppWorker()
            w.webAPIUSeCase  = resolver.resolve(RootAssemblyContainerProtocols.galleryAppAPIUseCase)
            w.genericUseCase = resolver.resolve(RootAssemblyContainerProtocols.galleryAppGenericAppBusinessUseCase)
            return w
        }

        // use case
        container.register(RootAssemblyContainerProtocols.galleryAppGenericAppBusinessUseCase) { resolver in
            let uc = GalleryAppMiscBusinessUseCase()
            uc.coldKeyValuesRepository = resolver.resolve(RootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(RootAssemblyContainerProtocols.hotCacheRepository)
            return uc
        }

        // use case
        container.register(RootAssemblyContainerProtocols.galleryAppAPIUseCase) { resolver in
            let uc = GalleryAppWebAPIUseCase()
            uc.networkRepository       = resolver.resolve(RootAssemblyContainerProtocols.galleryAppNetWorkRepository) // Client WebAPI
            uc.coldKeyValuesRepository = resolver.resolve(RootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(RootAssemblyContainerProtocols.hotCacheRepository)
            uc.apiCache                = resolver.resolve(RootAssemblyContainerProtocols.apiCacheRepository)
            return uc
        }
    }

}
