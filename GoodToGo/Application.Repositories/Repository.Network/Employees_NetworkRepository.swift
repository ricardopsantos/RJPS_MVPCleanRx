//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//


import Foundation
import RJPSLib

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */
extension Repository.Network {
    class Employees_NetworkRepository: Samples_NetWorkRepositoryProtocol {
        func netWork_OperationA(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RN.GetEmployees_APIRequest()
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<[E.Employee]>>) in
                    completionHandler(result)
                })
            }
            catch (let error) {
                completionHandler(Result.failure(error))
            }
        }
        
        func netWork_OperationB(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler) {
            AppLogs.DLog(code: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(code: .notImplemented)))
        }

    }
}




