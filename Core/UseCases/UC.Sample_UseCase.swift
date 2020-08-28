//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib_Networking
//
import AppConstants
import PointFreeFunctions
import Domain
import Factory

public class Sample_UseCase: GenericUseCase, Sample_UseCaseProtocol {
    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    public func operation1(canUseCache: Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
        guard existsInternetConnection else {
            completionHandler(Result.failure(Factory.Errors.with(appCode: .noInternet)))
            return
        }

        let cacheKey      = "\(AppConstants.Cache.servicesCache).\(Sample_UseCase.self).operation1"
        let coreDatakey   = "\(cacheKey).lastUpdate"
        let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam

        if canUseCache {
            if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey) {
                completionHandler(Result.success(cachedValue as? [String] ?? []))
                return
            }
        }

        let response = ["\(Date.utcNow)"]
        completionHandler(Result.success(response))
        self.generic_CacheRepositoryProtocol.add(object: response as AnyObject, withKey: cacheKey)
    }

    public func operation2(param: String, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
        guard existsInternetConnection else {
            completionHandler(Result.failure(Factory.Errors.with(appCode: .noInternet)))
            return
        }

        let response = ["\(Date.utcNow)"]
        completionHandler(Result.success(response))

    }
}
