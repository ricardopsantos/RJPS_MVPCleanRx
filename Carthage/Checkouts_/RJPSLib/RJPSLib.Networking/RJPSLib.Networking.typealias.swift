//
//  Created by Ricardo Santos on 11/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

//
// typealias? Why?
//
// When using RJSLib on other projects, instead of using `RJSLibNetworkClientResponse`, we can use `RJS_SimpleNetworkClientResponse` which can be more elegant to use
// Also, when using RJSLib, we can type `RJS_` and the Xcode auto-complete feature will suggest only thing inside RJSLib
//

public enum Result<T> {
    case success(T)
    case failure(Error)
}

// MARK: - NetWork Clients

public typealias RJS_BasicNetworkClient  = RJSLib.BasicNetworkClient // Simple GETs and images download
public typealias RJS_SimpleNetworkClient = RJSLib.SimpleNetworkClient

// MARK: - Web API

public typealias RJS_SimpleNetworkClientProtocol        = SimpleNetworkClient_Protocol
public typealias RJS_SimpleNetworkClientRequestProtocol = SimpleNetworkClientRequest_Protocol
public typealias RJS_SimpleNetworkClientResponse        = RJSLibNetworkClientResponse     // <T: Codable>
public typealias RJS_SimpleNetworkClientResponseType    = RJSLibNetworkClientResponseType // enum
