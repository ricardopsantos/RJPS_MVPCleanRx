//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJSLibUFBase

public protocol SimpleNetworkClientRequest_Protocol {
    var urlRequest: URLRequest { get }
    var responseType: RJSLibNetworkClientResponseType { get set }
    var debugRequest: Bool { get set }
    var returnOnMainTread: Bool { get set }
    var mockedData: String? { get }
}

public protocol SimpleNetworkClient_Protocol {
    func execute<T>(request: SimpleNetworkClientRequest_Protocol, completionHandler: @escaping (_ result: Result<RJSLibNetworkClientResponse<T>>) -> Void)
}

public protocol SimpleNetworkClientURLSession_Protocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SimpleNetworkClientURLSession_Protocol { }

private func synced<T>(_ lock: Any, closure: () -> T) -> T {
    objc_sync_enter(lock)
    let r = closure()
    objc_sync_exit(lock)
    return r
}

public extension RJSLib {
    class SimpleNetworkClient: SimpleNetworkClient_Protocol {
        let urlSession: SimpleNetworkClientURLSession_Protocol

        public enum HttpMethod: String {
            case get = "GET"
            case post = "POST"
            case put = "PUT"
            case delete = "DELETE"
        }

        public init(urlSessionConfiguration: URLSessionConfiguration=URLSessionConfiguration.default, completionHandlerQueue: OperationQueue = OperationQueue.main) {
            urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
        }
        
        // Used mainly for testing purposes
        public init(urlSession: SimpleNetworkClientURLSession_Protocol) {
            self.urlSession = urlSession
        }
        
        // MARK: - ApiClient
        public func execute<T>(request: SimpleNetworkClientRequest_Protocol, completionHandler: @escaping (Result<RJSLibNetworkClientResponse<T>>) -> Void) {

            //
            // Mock data
            //
            if request.mockedData != nil {
                let mockedData = request.mockedData!.trimmingCharacters(in: .whitespacesAndNewlines)
                if mockedData.count>0 {
                    do {
                        let data: Data? = mockedData.data(using: .utf8) // non-nil
                        let response = try RJSLibNetworkClientResponse<T>(data: data, httpUrlResponse: nil, responseType: request.responseType)
                        DispatchQueue.main.async {
                            print("# RJSLib.SimpleNetworkClient - Returned mocked data for [\(request.urlRequest)]")
                            completionHandler(.success(response))
                        }
                    } catch {
                        // Fail! Log and continue request
                        assertionFailure("Error [\(error)] returning mocked data for [\(request.urlRequest)] with data\n\n\(mockedData))")
                    }
                }
            }

            let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in

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
                                let dataString: String = String(data: data!, encoding: .utf8) ?? ""
                                print("# RJSLib.SimpleNetworkClient - Request: \(String(describing: request.urlRequest.url?.absoluteURL))\n# Response:\(dataString)")
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
                }
                
                if request.returnOnMainTread {
                    DispatchQueue.main.async { doWork() }
                } else { doWork() }
            }
            dataTask.resume()
        }
    }
}
