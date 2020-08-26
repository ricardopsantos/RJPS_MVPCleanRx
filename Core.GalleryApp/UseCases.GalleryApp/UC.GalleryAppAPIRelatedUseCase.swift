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

    public func search(cacheStrategy: CacheStrategy) -> Observable<Result<GalleryApp.AvailabilityResponseDto>> {
        let cacheKey = "\(GalleryAppAPIRelatedUseCase.self).\(#function)"
        //let cacheKey = "maria"

        var apiObserver: Observable<GalleryApp.AvailabilityResponseDto> {
            return Observable<GalleryApp.AvailabilityResponseDto>.create { observer in
                self.repositoryNetwork.search { (result) in
                    switch result {
                    case .success(let some) :
                        _ = RJS_DataModel.PersistentSimpleCacheWithTTL.shared.saveObject(some.entity, withKey: cacheKey, keyParams: [], lifeSpam: 60)
                        observer.on(.next(some.entity))
                    case .failure(let error): observer.on(.error(error))
                    }
                    observer.on(.completed)
                }
                return Disposables.create()
            }
        }

        let apiObserverResult = apiObserver.flatMap { (results) -> Observable<Result<GalleryApp.AvailabilityResponseDto>> in
            //print(results)
            return Observable.just(Result.success(results))
        }.catchError { (error) -> Observable<Result<GalleryApp.AvailabilityResponseDto>> in
            return Observable.just(Result.failure(error))
        }

        let cacheObserver = genericCacheObserver(GalleryApp.AvailabilityResponseDto.self,
                                                 cacheKey: cacheKey,
                                                 keyParams: [],
                                                 apiObserver: apiObserver.asSingle())

        let cacheObserverResult = cacheObserver.flatMap { (results) -> Observable<Result<GalleryApp.AvailabilityResponseDto>> in
            return Observable.just(Result.success(results))
        }.catchError { (error) -> Observable<Result<GalleryApp.AvailabilityResponseDto>> in
            return Observable.just(Result.failure(error))
        }

        switch cacheStrategy {
        case .noCacheLoad: return apiObserverResult.asObservable()
        case .cacheElseLoad: return cacheObserverResult.asObservable()
        case .cacheAndLoad: return Observable.merge(cacheObserverResult, apiObserverResult.asObservable() )
        case .cacheNoLoad: fatalError("Not safe!")
        }
    }

    public func getUserDetailV1(completionHandler: @escaping XXXXCompletionHandler) {
        self.repositoryNetwork.search { (result) in
            switch result {
            case .success(let some) : completionHandler(Result.success(some.entity))
            case .failure(let error): completionHandler(Result.failure(error))
            }
        }
    }
}

public typealias XXXXCompletionHandler = (_ result: Result<GalleryApp.AvailabilityResponseDto>) -> Void
