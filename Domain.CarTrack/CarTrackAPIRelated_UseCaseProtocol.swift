//
//  File.swift
//  Domain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib
import RxSwift
//
import Domain

/**
Use case Protocol for things related with the Web API. (Its not the API Protocol)
 */

public typealias CarTrackAPI_UseCaseCompletionHandler = (_ result: Result<[CarTrack.CarTrackUserResponseDtoElement]>) -> Void

public protocol CarTrackAPIRelated_UseCaseProtocol: class {

    /// returns Result<T> with completion handler
    func getUserDetailV1(completionHandler: @escaping CarTrackAPI_UseCaseCompletionHandler)

    /// returns a Observer
    func getUserDetailV2(cacheStrategy: CacheStrategy) -> Observable<[CarTrack.CarTrackUserResponseDtoElement]>

    /// Mix of the Observer version and the Result<T>
    func getUserDetailV3(cacheStrategy: CacheStrategy) -> Observable<Result<[CarTrack.CarTrackUserResponseDtoElement]>>
}
