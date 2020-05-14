//
//  File.swift
//  Domain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
import RxSwift

public typealias CarTrackAPI_UseCaseCompletionHandler = (_ result: Result<[CarTrack.CarTrackUserResponseDtoElement]>) -> Void

public protocol CarTrackAPI_UseCaseProtocol: class {
    func getUserDetail(completionHandler: @escaping CarTrackAPI_UseCaseCompletionHandler)
    func getUserDetail(cacheStrategy: CacheStrategy) -> Observable<[CarTrack.CarTrackUserResponseDtoElement]>
}
