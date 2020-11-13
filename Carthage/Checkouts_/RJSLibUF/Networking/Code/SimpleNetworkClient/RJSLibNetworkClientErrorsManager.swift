//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

struct RJSLibNetworkClientErrorsManager {
    
    public enum NetworkClient_ErrorCode: Int {
        case ok                  = 200
        case notFound            = 404
        case forbidden           = 403
        case internalServerError = 500
        case timeOut             = 504
        case generic             = 999
    }
    
    struct APIError: Error {
        let data: Data?
        let httpUrlResponse: HTTPURLResponse
    }
    
    struct ClientError: Error {
        static let code: Int = NetworkClient_ErrorCode.generic.rawValue
        let error: Error
        let httpUrlResponse: HTTPURLResponse?
        let data: Data?
        var reason: String
        var localizedDescription: String { return error.localizedDescription }
    }
    
    struct Custom {
        private static func errorWith(message: String) -> NSError { return NSError(domain: message, code: NetworkClient_ErrorCode.generic.rawValue, userInfo: nil) }
        static var parseError: Error { return errorWith(message: "Parse error") }
        static func with(error: Error) -> Error { return error }
    }
    
    static func logError(response: HTTPURLResponse, request: SimpleNetworkClientRequest_Protocol) {
        let successRange = 200...299
        guard !successRange.contains(response.statusCode) else { return }
        
        func log(request: SimpleNetworkClientRequest_Protocol, status: Int, info: String="") {
            let url = request.urlRequest.url!.absoluteURL
            assertionFailure("# Request [\(url)] failed with status code \(status)] \(info)")
        }
        
        let statusCode = response.statusCode
        if let status = NetworkClient_ErrorCode(rawValue: statusCode) {
            switch status {
            case .ok                  : log(request: request, status: statusCode, info: "OK")
            case .notFound            : log(request: request, status: statusCode, info: "Not Found")
            case .internalServerError : log(request: request, status: statusCode, info: "Internal Server Error")
            case .timeOut             : log(request: request, status: statusCode, info: "TimeOut")
            case .forbidden           : log(request: request, status: statusCode, info: "Forbidden")
            case .generic             : log(request: request, status: statusCode, info: "generic")
            }
        } else {
            log(request: request, status: statusCode, info: "\(response.debugDescription)")
        }
    }
}
