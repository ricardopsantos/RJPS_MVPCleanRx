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
// MARK: - Protocols references sugar
//

struct DIAssemblyContainerCartTrackProtocols {
    static let carTrackAppWorker                 = CarTrackWorkerProtocol.self
    static let carTrackAPIUseCase                = CarTrackWebAPIUseCaseProtocol.self             // UseCase - WebAPI
    static let carTrackGenericAppBusinessUseCase = CarTrackGenericAppBusinessUseCaseProtocol.self // UseCase - Generic
    static let carTrack_NetWorkRepository        = CarTrackNetWorkRepositoryProtocol.self         // Repository - WebAPI
}

//
// MARK: - Resolvers
//

public class CarTrackResolver {
    private init() { }
    public static let worker = DIAssemblerScenes.assembler.resolver.resolve(DIAssemblyContainerCartTrackProtocols.carTrackAppWorker.self)
}

//
// MARK: - Assembly Container
//

final class DIAssemblyContainerCarTrack: Assembly {
    func assemble(container: Container) {

        if DevTools.isMockApp {
            container.autoregister(DIAssemblyContainerCartTrackProtocols.carTrack_NetWorkRepository,
                                   initializer: WebAPI.CarTrack.NetWorkRepositoryMock.init).inObjectScope(.container)
        } else {
            container.autoregister(DIAssemblyContainerCartTrackProtocols.carTrack_NetWorkRepository,
                                   initializer: WebAPI.CarTrack.NetWorkRepository.init).inObjectScope(.container)
        }

        // worker
        container.register(DIAssemblyContainerCartTrackProtocols.carTrackAppWorker) { resolver in
            let w = CarTrackWorker()
            w.webAPIUSeCase  = resolver.resolve(DIAssemblyContainerCartTrackProtocols.carTrackAPIUseCase)
            w.genericUseCase  = resolver.resolve(DIAssemblyContainerCartTrackProtocols.carTrackGenericAppBusinessUseCase)
            return w
        }

        container.register(DIAssemblyContainerCartTrackProtocols.carTrackAPIUseCase) { resolver in
            let uc = CarTrackAPIUseCase()
            uc.networkRepository       = resolver.resolve(DIAssemblyContainerCartTrackProtocols.carTrack_NetWorkRepository)
            uc.coldKeyValuesRepository = resolver.resolve(RootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository      = resolver.resolve(RootAssemblyContainerProtocols.hotCacheRepository)
            uc.apiCache                = resolver.resolve(RootAssemblyContainerProtocols.apiCacheRepository)
            return uc
        }

        container.register(DIAssemblyContainerCartTrackProtocols.carTrackGenericAppBusinessUseCase) { resolver in
            let uc = Core_CarTrack.CarTrackGenericAppBusinessUseCase()
            uc.coldKeyValuesRepository  = resolver.resolve(RootAssemblyContainerProtocols.coldKeyValuesRepository)
            uc.hotCacheRepository       = resolver.resolve(RootAssemblyContainerProtocols.hotCacheRepository)
            return uc
        }
    }
}
