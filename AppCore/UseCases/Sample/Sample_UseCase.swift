//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain
import Factory

//public extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
 public class Sample_UseCase: GenericUseCase, Sample_UseCaseProtocol {
    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
    public var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!
        
    public func operation1(canUseCache: Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
            guard existsInternetConnection else {
                completionHandler(Result.failure(Factory.Errors.with(appCode: .noInternet)))
                return
            }
            
            let cacheKey      = "\(AppConstants.Cache.servicesCache).\(Sample_UseCase.self).operation1"
            let coreDatakey   = "\(cacheKey).lastUpdate"
            let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
            
            if canUseCache && !cachedValueIsOld(coreDatakey: coreDatakey, maxLifeSpam: cacheLifeSpam) {
                if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey) {
                    completionHandler(Result.success(cachedValue as! [String]))
                    return
                }
            }
            
            DispatchQueue.executeWithDelay(delay: 1) { [weak self] in
                let response = ["\(Date.utcNow)"]
                completionHandler(Result.success(response))
                self?.generic_CacheRepositoryProtocol.add(object: response as AnyObject, withKey: cacheKey)
            }
        }
        
    public func operation2(param: String, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
            guard existsInternetConnection else {
                completionHandler(Result.failure(Factory.Errors.with(appCode: .noInternet)))
                return
            }
            
            DispatchQueue.executeWithDelay(delay: 1) {
                let response = ["\(Date.utcNow)"]
                completionHandler(Result.success(response))
            }
        }
        
    }
//}
