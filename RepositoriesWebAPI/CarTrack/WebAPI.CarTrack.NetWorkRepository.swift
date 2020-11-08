//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJSLibUFNetworking
//
import DevTools
import AppConstants
import DomainCarTrack

/**
* WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
*/

public extension WebAPI.CarTrack {

    class NetWorkRepository: CarTrackNetWorkRepositoryProtocol {

        public init() { }

        public func getUsers(_ request: CarTrackRequests.GetUsers, completionHandler: @escaping (_ result: Result<RJS_SimpleNetworkClientResponse<[CarTrackResponseDto.User]>>) -> Void) {
            do {
                let apiRequest: WebAPIRequestProtocol = try WebAPI.CarTrackAPIRequest.GetUsers(request: request)
                let apiClient: RJS_SimpleNetworkClientProtocol = RJS_SimpleNetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJS_SimpleNetworkClientResponse<[CarTrackResponseDto.User]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
