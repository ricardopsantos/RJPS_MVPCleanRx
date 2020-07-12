//
//  RJPSLib.Networking.typelias.swift
//  RJPSLib.Networking
//
//  Created by Ricardo Santos on 11/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib_Base

public enum Result<T> {
    case success(T)
    case failure(Error)
}

// MARK: - NetWork Clients

public typealias RJS_BasicNetworkClient = RJSLib.BasicNetworkClient // Simple GETs and images download
public typealias RJS_NetworkClient      = RJSLib.NetworkClient

// MARK: - Web API

public typealias RJS_NetworkClientProtocol        = RJSLibNetworkClient_Protocol
public typealias RJS_NetworkClientRequestProtocol = RJSLibNetworkClientRequest_Protocol
public typealias RJS_NetworkClientResponse        = RJSLibNetworkClientResponse     // <T: Codable>
public typealias RJS_NetworkClientResponseType    = RJSLibNetworkClientResponseType // enum
