//
//  CarTrackGenericAppBusiness_UseCase.swift
//  AppCore
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain
import Domain_CarTrack
import Factory
import AppCore

public class CarTrackGenericAppBusinessUseCase: GenericUseCase, CarTrackGenericAppBusinessUseCaseProtocol {

    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
    public var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!

    public func validate(user: String,
                         password: String,
                         completionHandler: @escaping CarTrackGenericAppBusinessUseCaseCompletionHandler) {
        // Simulate some kind of API call
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.executeWithDelay(delay: 1) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let kPassword = "12345"
            let success = kPassword == password
            if success {
                completionHandler(Result.success(success))
            } else {
                completionHandler(Result.failure(Factory.Errors.with(appCode: .invalidCredentials)))
            }
        }
    }
}
