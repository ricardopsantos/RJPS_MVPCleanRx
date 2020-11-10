//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJSLibUFNetworking
//
import BaseConstants
import PointFreeFunctions
import BaseDomain
import Factory
import BaseCore
import DomainCarTrack

public class CarTrackGenericAppBusinessUseCase: GenericUseCase, CarTrackGenericAppBusinessUseCaseProtocol {

    public override init() { super.init() }

    public var hotCacheRepository: HotCacheRepositoryProtocol!              // resolved at class DIAssemblyContainerCarTrack
    public var coldKeyValuesRepository: KeyValuesStorageRepositoryProtocol! // resolved at class DIAssemblyContainerCarTrack

    public func validate(user: String,
                         password: String,
                         completionHandler: @escaping (_ result: Result<Bool>) -> ()) {
        // Simulate some kind of API call
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.executeWithDelay(delay: 1) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let success = user.lowercased() == AppConstants.Misc.sampleEmail.lowercased()
                &&
                password.lowercased() ==  AppConstants.Misc.samplePassword.lowercased()
            if success {
                completionHandler(Result.success(success))
            } else {
                completionHandler(Result.failure(Factory.Errors.with(appCode: .invalidCredentials)))
            }
        }
    }
}
