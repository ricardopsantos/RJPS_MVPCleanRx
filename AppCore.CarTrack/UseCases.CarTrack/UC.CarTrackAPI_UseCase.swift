//
//  CartTrack.swift
//  AppCore
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import AppCore
import Domain
import Domain_CarTrack
import Factory

// swiftlint:disable rule_Coding

public class CarTrackAPI_UseCase: GenericUseCase, CarTrackAPIRelated_UseCaseProtocol {

    public override init() { super.init() }

    public var repositoryNetwork: CarTrack_NetWorkRepositoryProtocol!
    public var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
    public var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!

    public func getUserDetailV3(cacheStrategy: CacheStrategy) -> Observable<Result<[CarTrack.CarTrackUserResponseDtoElement]>> {
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

    public func getUserDetailV2(cacheStrategy: CacheStrategy) -> Observable<[CarTrack.CarTrackUserResponseDtoElement]> {

        let cacheKey = "\(CarTrackAPI_UseCase.self).getUserDetail"
        let cacheKeyParams: [String] = []
        let apiObserver = getUserDetailObserver(cacheKey, cacheKeyParams)

        let cacheObserver = genericCacheObserver([CarTrack.CarTrackUserResponseDtoElement].self,
                                                    cacheKey: cacheKey,
                                                    keyParams: cacheKeyParams,
                                                    apiObserver: apiObserver.asSingle())

        switch cacheStrategy {
        case .reloadIgnoringCache: return apiObserver.asObservable()
        case .returnCacheElseLoad: return cacheObserver.asObservable()
        case .cacheAndLatestValue: return Observable.merge(cacheObserver, apiObserver.asObservable() )
        }
    }

    // Rx wrapper around [public func getUserDetail(completionHandler: @escaping CarTrackAPI_UseCaseCompletionHandler)]
    #warning("make it a Single")
    private func getUserDetailObserver(_ cacheKey: String, _ cacheKeyParams: [String]) -> Observable<[CarTrack.CarTrackUserResponseDtoElement]> {
        return Observable<[CarTrack.CarTrackUserResponseDtoElement]>.create { [weak self] observer in
            self?.getUserDetailV1 { (result) in
                switch result {
                case .success(let some) :
                    _ = RJS_DataModel.SimpleCache.saveObject(some, withKey: cacheKey, keyParams: cacheKeyParams, lifeSpam: 60)
                    observer.on(.next(some))
                case .failure(let error): observer.on(.error(error))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    public func getUserDetailV1(completionHandler: @escaping CarTrackAPI_UseCaseCompletionHandler) {
        self.repositoryNetwork.userDetails { (result) in
            switch result {
            case .success(let some) : completionHandler(Result.success(some.entity))
            case .failure(let error): completionHandler(Result.failure(error))
            }
        }
    }
}
