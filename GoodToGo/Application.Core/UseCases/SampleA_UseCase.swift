//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
    class Sample_UseCase : GenericUseCase, Sample_UseCaseProtocol {
        
        var generic_CacheRepositoryProtocol : Generic_CacheRepositoryProtocol!
        var generic_LocalStorageRepository  : Generic_LocalStorageRepositoryProtocol!
        
        func operation1(canUseCache: Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            let cacheKey      = "\(AppConstants.Cache.servicesCache).\(Sample_UseCase.self).operation1"
            let coreDatakey   = "\(cacheKey).lastUpdate"
            let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
            
            if(canUseCache && !cachedValueIsOld(coreDatakey:coreDatakey, maxLifeSpam:cacheLifeSpam)) {
                if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey)  {
                    completionHandler(Result.success(cachedValue as! [String]))
                    return
                }
            }
            
            DispatchQueue.executeWithDelay (delay:1) { [weak self] in
                let response = ["\(Date.utcNow())"]
                completionHandler(Result.success(response))
                self?.generic_CacheRepositoryProtocol.add(object: response as AnyObject, withKey: cacheKey)
            }
        }
        
        func operation2(param: String, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            DispatchQueue.executeWithDelay (delay:1) {
                let response = ["\(Date.utcNow())"]
                completionHandler(Result.success(response))
            }
        }
        
    }
}



