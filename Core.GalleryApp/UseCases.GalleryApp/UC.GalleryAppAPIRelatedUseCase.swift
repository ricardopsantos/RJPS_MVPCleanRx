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
    // (Converting Dto entities to Model entities will be done above on the worker)
    public func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppResponseDto.Availability>> {
        let cacheKey = "\(#function).\(request)"

        // API
        var apiObserver: Observable<GalleryAppResponseDto.Availability> {
            return Observable<GalleryAppResponseDto.Availability>.create { observer in
                self.repositoryNetwork.search(request) { (result) in
                    switch result {
                    case .success(let some) :
                        observer.on(.next(some.entity))
                        // Update cache (60m cache)
                        _ = RJS_DataModel.PersistentSimpleCacheWithTTL.shared.saveObject(some.entity.toDomain, withKey: cacheKey, keyParams: [], lifeSpam: 60)
                    case .failure(let error): observer.on(.error(error))
                    }
                    observer.on(.completed)
                }
                return Disposables.create()
            }
        }

        // Cache
        let cacheObserver = genericCacheObserver(GalleryAppResponseDto.Availability.self,
                                                 cacheKey: cacheKey,
                                                 keyParams: [],
                                                 apiObserver: apiObserver.asSingle())

        // Handle by cache strategie
        let apiObserverResult = apiObserver.flatMap { Observable.just(Result.success($0)) }.catchError { Observable.just(Result.failure($0)) }
        let cacheObserverResult = cacheObserver.flatMap { Observable.just(Result.success($0)) }.catchError { Observable.just(Result.failure($0)) }

        switch cacheStrategy {
        case .noCacheLoad: return apiObserverResult.asObservable()
        case .cacheElseLoad: return cacheObserverResult.asObservable()
        case .cacheAndLoad: return Observable.merge(cacheObserverResult, apiObserverResult.asObservable() )
        case .cacheNoLoad: fatalError("Not safe!")
        }
    }
}
