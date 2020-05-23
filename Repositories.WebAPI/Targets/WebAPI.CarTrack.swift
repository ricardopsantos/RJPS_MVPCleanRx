//
//  File.swift
//  API
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib
//
import DevTools
import Domain_CarTrack

/**
* WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
*/

public extension API.CarTrack {

    class NetWorkRepository: CarTrack_NetWorkRepositoryProtocol {

        public init() { }

        public func userDetails(completionHandler: @escaping CarTrack_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.CarTrackAPIRequest.GetUserInfo(userName: "")
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<[CarTrack.CarTrackUserResponseDtoElement]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
