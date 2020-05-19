//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
//
import Domain
import Domain_GitHub

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */

public extension API.GitUser {
    class NetWorkRepository: GitUser_NetWorkRepositoryProtocol {

        public init() { }
        
        public func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.GitUser.GetUserInfo_APIRequest(userName: userName)
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<GitHub.UserResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.GitUser.GetFriends_APIRequest(userName: userName)
                let apiClient: RJSLibNetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<[GitHub.UserResponseDto]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
