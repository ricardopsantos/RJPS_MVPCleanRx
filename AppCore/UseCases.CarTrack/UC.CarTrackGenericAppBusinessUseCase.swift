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

extension UC {
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
                let kUserName = "ricardo@gmail.com" //RJSLib.Storages.Keychain.readFromKeychain("username")
                let kPassword = "12345"             // RJSLib.Storages.Keychain.readFromKeychain("password")
                let success = kUserName.lowercased() == user.lowercased() && kPassword == password
                completionHandler(Result.success(success))
            }
        }
    }
}
