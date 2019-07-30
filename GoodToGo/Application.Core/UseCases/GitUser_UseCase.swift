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
    
    class GitUser_UseCase : GenericUseCase, GitUser_UseCaseProtocol {

        var generic_CacheRepositoryProtocol : Generic_CacheRepositoryProtocol!
        var repositoryNetwork               : GitUser_NetWorkRepositoryProtocol!

        func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_UseCaseCompletionHandler) {
            
            guard existsInternetConnection else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            let cacheKey      = "\(AppConstants.Cache.servicesCache).\(GitUser_UseCase.self).getInfoOfUserWith\(userName)"
            let coreDatakey   = "\(cacheKey).lastUpdate"
            let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
            
            if canUseCache && !cachedValueIsOld(coreDatakey:coreDatakey, maxLifeSpam:cacheLifeSpam) {
                if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey)  {
                    completionHandler(Result.success(cachedValue as! E.GitHubUser))
                    return
                }
            }
            
            repositoryNetwork.getInfoOfUserWith(userName: userName, canUseCache: true, completionHandler: { [weak self] result in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                switch result {
                case .success(let some):
                    let user : E.GitHubUser = some.entity
                    completionHandler(Result.success(user))
                    strongSelf.generic_CacheRepositoryProtocol.add(object: some.entity as AnyObject, withKey: cacheKey)
                    break
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    break
                }
            })
        }
        
        func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_UseCaseCompletionHandler) {
            
            guard existsInternetConnection else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            let cacheKey      = "\(AppConstants.Cache.servicesCache).\(GitUser_UseCase.self).getFriendsOfUserWith\(userName)"
            let coreDatakey   = "\(cacheKey).lastUpdate"
            let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
            
            if canUseCache && !cachedValueIsOld(coreDatakey:coreDatakey, maxLifeSpam:cacheLifeSpam) {
                if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey)  {
                    completionHandler(Result.success(cachedValue as! [E.GitHubUser]))
                    return
                }
            }
            
            repositoryNetwork.getFriendsOfUserWith(userName: userName, canUseCache: true, completionHandler: { [weak self] result in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                switch result {
                case .success(let some):
                    let friends : [E.GitHubUser] = some.entity
                    completionHandler(Result.success(friends))
                    strongSelf.generic_CacheRepositoryProtocol.add(object: some.entity as AnyObject, withKey: cacheKey)
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            })
        }
    }
    
}




