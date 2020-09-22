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
import Domain_CarTrack
import Repositories
import Repositories_WebAPI
import Core
import Core_CarTrack
import DevTools
//
// MARK: - Resolvers
//

public class CarTrackResolver {
    private init() { }
    public static let worker = ApplicationScenesAssembly.assembler.resolver.resolve(RootAssemblyContainerProtocols.carTrackAppWorker.self)
}

final class CarTrackAssemblyContainer: Assembly {
    func assemble(container: Container) {
        //
        // CarTrack
        //

        if DevTools.isMockApp {
            container.autoregister(RootAssemblyContainerProtocols.carTrack_NetWorkRepository,
                                   initializer: WebAPI.CarTrack.NetWorkRepositoryMock.init).inObjectScope(.container)
        } else {
            container.autoregister(RootAssemblyContainerProtocols.carTrack_NetWorkRepository,
                                   initializer: WebAPI.CarTrack.NetWorkRepository.init).inObjectScope(.container)
        }

        // worker
        container.register(RootAssemblyContainerProtocols.carTrackAppWorker) { resolver in
            let w = CarTrackWorker()
            w.webAPIUSeCase  = resolver.resolve(RootAssemblyContainerProtocols.carTrackAPIUseCase)
            w.genericUseCase  = resolver.resolve(RootAssemblyContainerProtocols.carTrackGenericAppBusinessUseCase)
            return w
        }

        container.register(RootAssemblyContainerProtocols.carTrackAPIUseCase) { resolver in
            let uc = CarTrackAPIUseCase()
            uc.networkRepository       = resolver.resolve(RootAssemblyContainerProtocols.carTrack_NetWorkRepository)
            uc.coldKeyValuesRepository = resolver.resolve(RootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(RootAssemblyContainerProtocols.hotCacheRepository)
            uc.apiCache                = resolver.resolve(RootAssemblyContainerProtocols.apiCacheRepository)
            return uc
        }

        container.register(RootAssemblyContainerProtocols.carTrackGenericAppBusinessUseCase) { resolver in
            let uc = Core_CarTrack.CarTrackGenericAppBusinessUseCase()
            uc.coldKeyValuesRepository  = resolver.resolve(RootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository       = resolver.resolve(RootAssemblyContainerProtocols.hotCacheRepository)
            return uc
        }
    }
}
