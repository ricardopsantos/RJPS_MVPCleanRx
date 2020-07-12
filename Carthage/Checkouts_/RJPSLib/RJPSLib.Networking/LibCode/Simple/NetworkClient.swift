//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib_Base

public protocol RJSLibNetworkClientRequest_Protocol {
    var urlRequest: URLRequest { get }
    var responseType: RJSLibNetworkClientResponseType { get set }
    var debugRequest: Bool { get set }
    var returnOnMainTread: Bool { get set }
    var mockedData: String? { get }
}

public protocol RJSLibNetworkClient_Protocol {
    func execute<T>(request: RJSLibNetworkClientRequest_Protocol,
                    completionHandler: @escaping (_ result: Result<RJSLibNetworkClientResponse<T>>) -> Void)
}

public protocol RJSLibURLSession_Protocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: RJSLibURLSession_Protocol { }

public extension RJSLib {
    class NetworkClient: RJSLibNetworkClient_Protocol {
        let urlSession: RJSLibURLSession_Protocol

        public enum HttpMethod: String {
            case get = "GET"
            case post = "POST"
            case put = "PUT"
            case delete = "DELETE"
        }

        static var requests: [String] = []
        
        public init(urlSessionConfiguration: URLSessionConfiguration=URLSessionConfiguration.default, completionHandlerQueue: OperationQueue = OperationQueue.main) {
            urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
        }
        
        // Used mainly for testing purposes
        public init(urlSession: RJSLibURLSession_Protocol) {
            self.urlSession = urlSession
        }
        
        // MARK: - ApiClient
        public func execute<T>(request: RJSLibNetworkClientRequest_Protocol, completionHandler: @escaping (Result<RJSLibNetworkClientResponse<T>>) -> Void) {
            
            let cronometerId = request.urlRequest.url!.absoluteString
            if request.debugRequest {
                RJS_Cronometer.startTimmerWith(identifier: cronometerId)
            }
            
            //
            // Mock data
            //
            if request.mockedData != nil {
                let mockedData = request.mockedData!.trim
                if mockedData.count>0 {
                    do {
                        let data: Data? = mockedData.data(using: .utf8) // non-nil
                        let response = try RJSLibNetworkClientResponse<T>(data: data, httpUrlResponse: nil, responseType: request.responseType)
                        DispatchQueue.executeInMainTread {
                            RJS_Logs.message("Returned mocked data for [\(request.urlRequest)]")
                            completionHandler(.success(response))
                        }
                    } catch {
                        // Fail! Log and continue request
                        RJS_Logs.error("Error [\(error)] returning mocked data for [\(request.urlRequest)] with data\n\n\(mockedData))")
                    }
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkClient.requests.append("\(request)")
            
            let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
                if request.debugRequest { _ = RJS_Cronometer.timeElapsed(identifier: cronometerId, print: true) }
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(RJSLibNetworkClientErrorsManager.Custom.with(error: error!)))
                    return
                }
                
                let doWork = {
                    let successRange = 200...299
                    if successRange.contains(httpUrlResponse.statusCode) {
                        do {
                            let response = try RJSLibNetworkClientResponse<T>(data: data, httpUrlResponse: httpUrlResponse, responseType: request.responseType)
                            if request.debugRequest && data != nil {
                                let dataString: String! = String(data: data!, encoding: .utf8)
                                RJS_Logs.message("# Request: \(request.urlRequest.url!.absoluteURL)\n# Response:\(dataString!)")
                            }
                            completionHandler(.success(response))
                        } catch {
                            completionHandler(.failure(error))
                        }
                    } else {
                        if request.debugRequest {
                            RJSLibNetworkClientErrorsManager.logError(response: httpUrlResponse, request: request)
                        }
                        completionHandler(.failure(RJSLibNetworkClientErrorsManager.APIError(data: data, httpUrlResponse: httpUrlResponse)))
                    }
                    NetworkClient.requests.removeObject("\(request)")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = NetworkClient.requests.count > 0
                }
                
                if request.returnOnMainTread {
                    DispatchQueue.executeInMainTread { doWork() }
                } else { doWork() }
            }
            dataTask.resume()
        }
    }
}
