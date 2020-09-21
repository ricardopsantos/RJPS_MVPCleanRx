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

// READ! READ! READ! READ! READ! READ! READ! READ! READ!
// READ! READ! READ! READ! READ! READ! READ! READ! READ!
//
// For simplicity sake, the dependencies will be shared amount some target (GoodToGo & UIBase)
//
// READ! READ! READ! READ! READ! READ! READ! READ! READ!
// READ! READ! READ! READ! READ! READ! READ! READ! READ!
//

//
// MARK: - Protocols
//

struct RootAssemblyContainerProtocols {

    //
    // Managers
    //

    static let messagesManager = MessagesManagerProtocol.self

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
    static let galleryAppNetWorkRepository         = GalleryAppNetWorkRepositoryProtocol.self       // Repository - WebAPI
}

public class RootAssemblyResolver {
    private init() { }
    public static let messagesManager = ApplicationScenesAssembly.assembler.resolver.resolve(RootAssemblyContainerProtocols.messagesManager.self)
}

//
// MARK: - RootAssemblyContainer
//

final class CoreAssemblyContainer: Assembly {

    func assemble(container: Container) {

        container.autoregister(RootAssemblyContainerProtocols.messagesManager,
                               initializer: MessagesManager.init).inObjectScope(.container)

        //
        // Base app repositories
        //

        container.autoregister(RootAssemblyContainerProtocols.hotCacheRepository,
                               initializer: RP.HotCacheRepository.init).inObjectScope(.container)

        container.autoregister(RootAssemblyContainerProtocols.networkClient,
                               initializer: RJS_SimpleNetworkClient.init).inObjectScope(.container)

        container.autoregister(RootAssemblyContainerProtocols.coldKeyValuesRepository,
                               initializer: RP.KeyValuesStorageRepository.init).inObjectScope(.container)

        container.autoregister(RootAssemblyContainerProtocols.apiCacheRepository,
                               initializer: RP.APICacheManager.init).inObjectScope(.container)

    }
}
