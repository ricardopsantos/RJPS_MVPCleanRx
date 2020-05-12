//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public protocol RJSLibWebAPIRequest_Protocol {
    var urlRequest: URLRequest { get }
    var responseType: NetworkClientResponseType { get set }
    var debugRequest: Bool { get set }
    var returnOnMainTread: Bool { get set }
    var mockedData: String? { get }
}

public protocol NetworkClient_Protocol {
    func execute<T>(request: RJSLibWebAPIRequest_Protocol, completionHandler: @escaping (_ result: Result<NetworkClientResponse<T>>) -> Void)
}

public protocol URLSession_Protocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSession_Protocol { }

extension RJSLib {
    public class NetworkClient: NetworkClient_Protocol {
        let urlSession: URLSession_Protocol
        
        static var requests: [String] = []
        
        public init(urlSessionConfiguration: URLSessionConfiguration=URLSessionConfiguration.default, completionHandlerQueue: OperationQueue = OperationQueue.main) {
            urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
        }
        
        // Used mainly for testing purposes
        public init(urlSession: URLSession_Protocol) {
            self.urlSession = urlSession
        }
        
        // MARK: - ApiClient
        public func execute<T>(request: RJSLibWebAPIRequest_Protocol, completionHandler: @escaping (Result<NetworkClientResponse<T>>) -> Void) {
            
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
                        let response = try NetworkClientResponse<T>(data: data, httpUrlResponse: nil, responseType: request.responseType)
                        DispatchQueue.executeInMainTread {
                            RJS_Logs.DLog("Returned mocked data for [\(request.urlRequest)]")
                            completionHandler(.success(response))
                        }
                    } catch {
                        // Fail! Log and continue request
                        RJS_Logs.DLogError("Error [\(error)] returning mocked data for [\(request.urlRequest)] with data\n\n\(mockedData))")
                    }
                }
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkClient.requests.append("\(request)")
            
            let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
                if request.debugRequest { _ = RJS_Cronometer.timeElapsed(identifier: cronometerId, print: true) }
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(NetworkClientErrorsManager.Custom.with(error: error!)))
                    return
                }
                
                let doWork = {
                    let successRange = 200...299
                    if successRange.contains(httpUrlResponse.statusCode) {
                        do {
                            let response = try NetworkClientResponse<T>(data: data, httpUrlResponse: httpUrlResponse, responseType: request.responseType)
                            if request.debugRequest && data != nil {
                                let dataString: String! = String(data: data!, encoding: .utf8)
                                RJS_Logs.DLog("# Request: \(request.urlRequest.url!.absoluteURL)\n# Response:\(dataString!)")
                            }
                            completionHandler(.success(response))
                        } catch {
                            completionHandler(.failure(error))
                        }
                    } else {
                        if request.debugRequest {
                            NetworkClientErrorsManager.logError(response: httpUrlResponse, request: request)
                        }
                        completionHandler(.failure(NetworkClientErrorsManager.APIError(data: data, httpUrlResponse: httpUrlResponse)))
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
