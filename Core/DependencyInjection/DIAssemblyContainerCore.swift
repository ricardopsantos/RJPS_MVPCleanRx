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
import Repositories
import Repositories_WebAPI
import DevTools

//
// MARK: - Protocols
//

public struct RootAssemblyContainerProtocols {

    //
    // Managers
    //

    public static let messagesManager = MessagesManagerProtocol.self

    //
    // Generic Repositories
    //

    public static let networkClient           = RJS_SimpleNetworkClientProtocol.self
    public static let hotCacheRepository      = HotCacheRepositoryProtocol.self
    public static let coldKeyValuesRepository = KeyValuesStorageRepositoryProtocol.self
    public static let apiCacheRepository      = APICacheManagerProtocol.self

}

//
// MARK: - Resolvers
//

public class RootAssemblyResolver {
    private init() { }
    public static let messagesManager = DIAssemblerCore.assembler.resolver.resolve(RootAssemblyContainerProtocols.messagesManager.self)
}

//
// MARK: - Assembly Container
//

final class DIAssemblyContainerCore: Assembly {

    func assemble(container: Container) {

        container.autoregister(RootAssemblyContainerProtocols.messagesManager,
                               initializer: MessagesManager.init).inObjectScope(.container)

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
