//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Networking
//
import DevTools
import Domain_GalleryApp

/**
* WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
*/

public extension API.GalleryApp {

    class NetWorkRepository: GalleryAppNetWorkRepositoryProtocol {

        public init() { }

        public func userDetails(completionHandler: @escaping GalleryAppNetWorkRepositoryCompletionHandler) {
          /*  do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.CarTrackAPIRequest.GetUserInfo(userName: "")
                let apiClient: RJS_SimpleNetworkClientProtocol = RJS_SimpleNetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJS_SimpleNetworkClientResponse<[CarTrack.CarTrackUserResponseDtoElement]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }*/
        }
    }
}
