//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib_Networking
import RJPSLib_Storage
//
import AppConstants
import PointFreeFunctions
import Core
import Domain
import Domain_GalleryApp
import Factory

// swiftlint:disable rule_Coding

public class GalleryAppAPIRelatedUseCase: GenericUseCase, GalleryAppAPIRelatedUseCaseProtocol {

    public override init() { super.init() }

    public var repositoryNetwork: GalleryAppNetWorkRepositoryProtocol!
    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    // Will
    // - Call the API
    // - Manage the Cache
    // Convert Dto entities to Model entities
    public func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.Availability>> {
        let cacheKey = "\(GalleryAppAPIRelatedUseCase.self).\(#function)"

        // Call
        var apiObserver: Observable<GalleryAppModel.Availability> {
            return Observable<GalleryAppModel.Availability>.create { observer in
                self.repositoryNetwork.search(request) { (result) in
                    switch result {
                    case .success(let some) :
                        _ = RJS_DataModel.PersistentSimpleCacheWithTTL.shared.saveObject(some.entity.toDomain, withKey: cacheKey, keyParams: [], lifeSpam: 60)
                        if let domain = some.entity.toDomain {
                            observer.on(.next(domain))
                        } else {
                            observer.on(.error(Factory.Errors.with(appCode: .parsingError)))
                        }
                    case .failure(let error): observer.on(.error(error))
                    }
                    observer.on(.completed)
                }
                return Disposables.create()
            }
        }

        // API Obj
        let apiObserverResult = apiObserver.flatMap { (results) -> Observable<Result<GalleryAppModel.Availability>> in
            return Observable.just(Result.success(results))
        }.catchError { (error) -> Observable<Result<GalleryAppModel.Availability>> in
            return Observable.just(Result.failure(error))
        }

        // Cache
        let cacheObserver = genericCacheObserver(GalleryAppModel.Availability.self,
                                                 cacheKey: cacheKey,
                                                 keyParams: [],
                                                 apiObserver: apiObserver.asSingle())

        let cacheObserverResult = cacheObserver.flatMap { (results) -> Observable<Result<GalleryAppModel.Availability>> in
            return Observable.just(Result.success(results))
        }.catchError { (error) -> Observable<Result<GalleryAppModel.Availability>> in
            return Observable.just(Result.failure(error))
        }

        switch cacheStrategy {
        case .noCacheLoad: return apiObserverResult.asObservable()
        case .cacheElseLoad: return cacheObserverResult.asObservable()
        case .cacheAndLoad: return Observable.merge(cacheObserverResult, apiObserverResult.asObservable() )
        case .cacheNoLoad: fatalError("Not safe!")
        }
    }
}
