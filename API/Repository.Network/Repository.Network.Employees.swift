//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib
//
import AppDomain
import DevTools

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */

public extension Network {
    struct Employees {
        private init() {}
    }
}

public extension Network.Employees {
    class NetworkRepository: Samples_NetWorkRepositoryProtocol {

        public init() { }

        public func netWork_OperationA(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try Network.Employees.GetEmployees_APIRequest()
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<[Employee.ResponseDto]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func netWork_OperationB(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler) {
            //AppLogger.log(appCode: .notImplemented)
            completionHandler(Result.failure(APIErrors.notImplemented))
        }
        
    }
}
