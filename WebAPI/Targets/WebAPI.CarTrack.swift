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
import Domain
import DevTools

public extension API.CarTrack {

    class NetWorkRepository: CarTrack_NetWorkRepositoryProtocol {

        public init() { }

        public func userDetails(canUseCache: Bool, completionHandler: @escaping CarTrack_UserDetailsNetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.CarTrack.GetUserInfo_APIRequest(userName: "")
                let apiClient: NetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<[CarTrack.CarTrackUserResponseDtoElement]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
