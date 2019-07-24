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
    class GitUser_NetWorkRepository: GitUser_NetWorkRepositoryProtocol {
        func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RN.GetUserInfo_APIRequest(userName: userName)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<E.GitHubUser>>) in
                    completionHandler(result)
                })
            }
            catch (let error) {
                completionHandler(Result.failure(error))
            }
        }
        
        func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RN.GetFriends_APIRequest(userName: userName)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<[E.GitHubUser]>>) in
                    completionHandler(result)
                })
            }
            catch (let error) {
                completionHandler(Result.failure(error))
            }
        }
    }
}




