//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//
/*
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

public class GalleryAppAPIUseCase: GenericUseCase, CarTrackAPIRelated_UseCaseProtocol {

    public override init() { super.init() }

    public var repositoryNetwork: CarTrack_NetWorkRepositoryProtocol!
    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    public func getUserDetailV3(cacheStrategy: CacheStrategy) -> Observable<Result<[GalleryApp.SampleModel1Dto]>> {
        let cacheKey = "\(CarTrackAPI_UseCase.self).getUserDetail"
        let cacheKeyParams: [String] = []

        let apiObserver = getUserDetailObserver(cacheKey, cacheKeyParams)

        let apiObserverResult = apiObserver.flatMap { (results) -> Observable<Result<[CarTrack.CarTrackUserResponseDtoElement]>> in
            return Observable.just(Result.success(results))
        }.catchError { (error) -> Observable<Result<[CarTrack.CarTrackUserResponseDtoElement]>> in
            return Observable.just(Result.failure(error))
        }

        let cacheObserver = genericCacheObserver([CarTrack.CarTrackUserResponseDtoElement].self,
                                                 cacheKey: cacheKey,
                                                 keyParams: cacheKeyParams,
                                                 apiObserver: apiObserver.asSingle())

        let cacheObserverResult = cacheObserver.flatMap { (results) -> Observable<Result<[CarTrack.CarTrackUserResponseDtoElement]>> in
            return Observable.just(Result.success(results))
        }.catchError { (error) -> Observable<Result<[CarTrack.CarTrackUserResponseDtoElement]>> in
            return Observable.just(Result.failure(error))
        }

        switch cacheStrategy {
        case .reloadIgnoringCache: return apiObserverResult.asObservable()
        case .returnCacheElseLoad: return cacheObserverResult.asObservable()
        case .cacheAndLatestValue: return Observable.merge(cacheObserverResult, apiObserverResult.asObservable() )
        }
    }
}
*/
