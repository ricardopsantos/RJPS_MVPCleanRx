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

//public extension UseCases {

public class GitUser_UseCase: GenericUseCase, GitUser_UseCaseProtocol {

        var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
        var repositoryNetwork: GitUser_NetWorkRepositoryProtocol!

    public func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_UseCaseCompletionHandler) {
            
            guard existsInternetConnection else {
                completionHandler(Result.failure(ErrorsFactory.with(appCode: .noInternet)))
                return
            }
            
            let cacheKey      = "\(AppConstants.Cache.servicesCache).\(GitUser_UseCase.self).getInfoOfUserWith\(userName)"
            let coreDatakey   = "\(cacheKey).lastUpdate"
            let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
            
            if canUseCache && !cachedValueIsOld(coreDatakey: coreDatakey, maxLifeSpam: cacheLifeSpam) {
                if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey) {
                    completionHandler(Result.success(cachedValue as! GitHub.UserResponseDto))
                    return
                }
            }
            
            repositoryNetwork.getInfoOfUserWith(userName: userName, canUseCache: true, completionHandler: { [weak self] result in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                switch result {
                case .success(let some):
                    let user: GitHub.UserResponseDto = some.entity
                    completionHandler(Result.success(user))
                    self.generic_CacheRepositoryProtocol.add(object: some.entity as AnyObject, withKey: cacheKey)
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            })
        }
        
    public func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_UseCaseCompletionHandler) {
            
            guard existsInternetConnection else {
                completionHandler(Result.failure(ErrorsFactory.with(appCode: .noInternet)))
                return
            }
            
            let cacheKey      = "\(AppConstants.Cache.servicesCache).\(GitUser_UseCase.self).getFriendsOfUserWith\(userName)"
            let coreDatakey   = "\(cacheKey).lastUpdate"
            let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
            
            if canUseCache && !cachedValueIsOld(coreDatakey: coreDatakey, maxLifeSpam: cacheLifeSpam) {
                if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey) {
                    completionHandler(Result.success(cachedValue as! [GitHub.UserResponseDto]))
                    return
                }
            }
            
            repositoryNetwork.getFriendsOfUserWith(userName: userName, canUseCache: true, completionHandler: { [weak self] result in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                switch result {
                case .success(let some):
                    let friends: [GitHub.UserResponseDto] = some.entity
                    completionHandler(Result.success(friends))
                    self.generic_CacheRepositoryProtocol.add(object: some.entity as AnyObject, withKey: cacheKey)
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            })
        }
    }
//}
