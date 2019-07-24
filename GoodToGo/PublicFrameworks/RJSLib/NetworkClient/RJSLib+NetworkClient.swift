//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

protocol APIRequest_Protocol {
    var urlRequest        : URLRequest { get }
    var responseType      : NetworkClientResponseType { get set }
    var debugRequest      : Bool { get set }
    var returnOnMainTread : Bool { get set }
}

protocol NetworkClient_Protocol {
    func execute<T>(request: APIRequest_Protocol, completionHandler: @escaping (_ result: Result<NetworkClientResponse<T>>) -> Void)
}

protocol URLSession_Protocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSession_Protocol { }

extension RJSLib {
    class NetworkClient: NetworkClient_Protocol {
        let urlSession: URLSession_Protocol
        
        init(urlSessionConfiguration: URLSessionConfiguration=URLSessionConfiguration.default, completionHandlerQueue: OperationQueue = OperationQueue.main) {
            urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
        }
        
        // Used mainly for testing purposes
        init(urlSession: URLSession_Protocol) {
            self.urlSession = urlSession
        }
        
        // MARK: - ApiClient
        func execute<T>(request: APIRequest_Protocol, completionHandler: @escaping (Result<NetworkClientResponse<T>>) -> Void) {
            
            let cronometerId = request.urlRequest.url!.absoluteString
            if(request.debugRequest) {
                RJSLib.RJSCronometer.startTimmerWith(id: cronometerId)
            }
            
            let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
                
                if(request.debugRequest) { let _ = RJSLib.RJSCronometer.timeElapsed(id: cronometerId, print: true) }
                
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(NetworkClientErrorsManager.Custom.with(error: error!)))
                    return
                }
                
                let doWork = {
                    let successRange = 200...299
                    if successRange.contains(httpUrlResponse.statusCode) {
                        do {
                            let response = try NetworkClientResponse<T>(data: data, httpUrlResponse: httpUrlResponse, responseType: request.responseType)
                            if(request.debugRequest && data != nil) {
                                let dataString: String! = String(data: data!, encoding: .utf8)
                                RJSLib.Logs.DLog("# Request: \(request.urlRequest.url!.absoluteURL)\n# Response:\(dataString!)")
                            }
                            completionHandler(.success(response))
                        }
                        catch {
                            completionHandler(.failure(error))
                        }
                    }
                    else {
                        if(request.debugRequest) {
                            NetworkClientErrorsManager.logError(response: httpUrlResponse, request: request)
                        }
                        completionHandler(.failure(NetworkClientErrorsManager.APIError(data: data, httpUrlResponse: httpUrlResponse)))
                    }
                }
                
                if(request.returnOnMainTread) { DispatchQueue.rjs.inMainTread { doWork() } }
                else { doWork() }
                
            }
            dataTask.resume()
        }
    }
}

