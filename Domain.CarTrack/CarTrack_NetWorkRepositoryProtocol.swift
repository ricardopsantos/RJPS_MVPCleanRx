//
//  CarTrack.swift
//  AppDomain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//

/**
Web API Requests Protocol
 */

public typealias CarTrack_NetWorkRepositoryCompletionHandler = (_ result: Result<RJSLibNetworkClientResponse<[CarTrack.CarTrackUserResponseDtoElement]>>) -> Void

public protocol CarTrack_NetWorkRepositoryProtocol: class {
    func userDetails(completionHandler: @escaping CarTrack_NetWorkRepositoryCompletionHandler)
}
