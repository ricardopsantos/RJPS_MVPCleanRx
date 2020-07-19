//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Networking
//
import Domain
import Domain_GitHub

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */

public extension API.GitHub {
    class NetWorkRepository: GitUser_NetWorkRepositoryProtocol {

        public init() { }
        
        public func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.GitHubAPIRequest.GetUserInfo(userName: userName)
                let apiClient: RJS_SimpleNetworkClientProtocol = RJS_SimpleNetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJS_SimpleNetworkClientResponse<GitHub.UserResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }

        public func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_NetWorkRepositoryCompletionHandler) {
           /* do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.GitHubAPIRequest.GetFriends(userName: userName)
                let apiClient: RJS_SimpleNetworkClientProtocol = RJS_SimpleNetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJS_SimpleNetworkClientResponse<[GitHub.UserRespoonseDto]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }*/
        }
    }
}
