//
//  Created by Ricardo Santos on 29/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
//
import RxSwift
import RxCocoa
import AppConstants
import DevTools
import Extensions
import PointFreeFunctions
import RJPSLib_Networking
import Factory
//
import AppResources
import Core
import Domain
import Domain_CarTrack

//
// The worker do the bridge between the Scenes and the UseCases
//

public protocol CarTrackWorkerProtocol {
    var webAPIUSeCase: CarTrackWebAPIUseCaseProtocol! { get set }
    var genericUseCase: CarTrackGenericAppBusinessUseCaseProtocol! { get set }

    func getUsers(request: CarTrackRequests.GetUsers, cacheStrategy: CacheStrategy) -> Observable<[CarTrackResponseDto.User]>
    func validate(user: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void)
}

public class CarTrackWorker {
    public var webAPIUSeCase: CarTrackWebAPIUseCaseProtocol!
    public var genericUseCase: CarTrackGenericAppBusinessUseCaseProtocol!
}

// MARK: - GalleryAppWorkerProtocol

extension CarTrackWorker: CarTrackWorkerProtocol {
    public func getUsers(request: CarTrackRequests.GetUsers, cacheStrategy: CacheStrategy) -> Observable<[CarTrackResponseDto.User]> {
        return webAPIUSeCase.getUsers(request: request, cacheStrategy: cacheStrategy)
    }

    public func validate(user: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        genericUseCase.validate(user: user, password: password) { (result) in completionHandler(result) }
    }
}
