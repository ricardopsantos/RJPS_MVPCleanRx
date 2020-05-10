//
//  File.swift
//  Domain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

public typealias CarTrackAPI_UseCaseCompletionHandler = (_ result: Result<[GitHub.UserResponseDto]>) -> Void

public protocol CarTrackAPI_UseCaseProtocol: class {
    func getUserDetail(userName: String, canUseCache: Bool, completionHandler: @escaping CarTrackAPI_UseCaseCompletionHandler)
}
