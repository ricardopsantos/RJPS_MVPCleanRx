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

public typealias CarTrack_UserDetailsNetWorkRepositoryCompletionHandler = (_ result: Result<RJSLibNetworkClientResponse<[CarTrack.CarTrackUserResponseDtoElement]>>) -> Void

public protocol CarTrack_NetWorkRepositoryProtocol: class {
    func userDetails(canUseCache: Bool, completionHandler: @escaping CarTrack_UserDetailsNetWorkRepositoryCompletionHandler)
}
