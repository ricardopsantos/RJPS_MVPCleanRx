//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib_Networking
//

/**
Web API Requests Protocol
 */

public protocol CarTrackNetWorkRepositoryProtocol: class {
    func getUsers(_ request: CarTrackRequests.GetUsers, completionHandler: @escaping (_ result: Result<RJS_SimpleNetworkClientResponse<[CarTrackResponseDto.User]>>) -> Void)
}
