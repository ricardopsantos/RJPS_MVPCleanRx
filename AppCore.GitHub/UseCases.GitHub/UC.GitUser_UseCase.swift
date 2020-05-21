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
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain
import Domain_GitHub
import Factory
import DevTools
import AppCore

public class GitUser_UseCase: GenericUseCase, GitHubAPIRelated_UseCaseProtocol {
    public override init() { super.init() }
    
    public  var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
    public var repositoryNetwork: GitUser_NetWorkRepositoryProtocol!
    
    public func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitHubAPIRelated_S1_UseCaseCompletionHandler) {
        
        guard existsInternetConnection else {
            completionHandler(Result.failure(Factory.Errors.with(appCode: .noInternet)))
            return
        }
        
        let cacheKey      = "\(AppConstants.Cache.servicesCache).\(GitUser_UseCase.self).getInfoOfUserWith\(userName)"
        let coreDatakey   = "\(cacheKey).lastUpdate"
        let cacheLifeSpam = AppConstants.Cache.serverRequestCacheLifeSpam
        
        if canUseCache && !cachedValueIsOld(coreDatakey: coreDatakey, maxLifeSpam: cacheLifeSpam) {
            if let cachedValue =  generic_CacheRepositoryProtocol.get(key: cacheKey) as? GitHub.UserResponseDto {
                completionHandler(Result.success(cachedValue))
                return
            }
        }
        
        repositoryNetwork.getInfoOfUserWith(userName: userName, canUseCache: true, completionHandler: { [weak self] result in
            guard let self = self else { return }
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
    
    public func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitHubAPIRelated_S2_UseCaseCompletionHandler) {
        
        guard existsInternetConnection else {
            completionHandler(Result.failure(Factory.Errors.with(appCode: .noInternet)))
            return
        }
        
        #warning("Old cache version. Change it to new version")
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
            guard let self = self else { return }
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
