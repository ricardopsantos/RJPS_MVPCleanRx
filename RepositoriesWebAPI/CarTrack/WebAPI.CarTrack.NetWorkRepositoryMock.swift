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
import DomainCarTrack
import AppConstants

/**
* WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
*/

public extension WebAPI.CarTrack {

    class NetWorkRepositoryMock: CarTrackNetWorkRepositoryProtocol {

        public init() { }

        public func getUsers(_ request: CarTrackRequests.GetUsers, completionHandler: @escaping (_ result: Result<RJS_SimpleNetworkClientResponse<[CarTrackResponseDto.User]>>) -> Void) {
            if let data = AppConstants.Mocks.CarTrack.get_200.data(using: .utf8),
                let response = try? RJS_SimpleNetworkClientResponse<[CarTrackResponseDto.User]>(data: data, httpUrlResponse: nil, responseType: .json) {
                completionHandler(Result.success(response))
            }
        }
    }
}
