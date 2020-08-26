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

public class OperationBase2: Operation {
    private var _executing = false {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    public override var isExecuting: Bool { return _executing }
    private var _finished = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    public override var isFinished: Bool { return _finished }
    func executing(_ executing: Bool) { _executing = executing }
    func finish(_ finished: Bool) { _finished = finished }
}

public class ImageInfoRequestOperation: OperationBase2 {
    var result: Result<GalleryAppResponseDto.ImageInfo>?
    private var block: Observable<Result<GalleryAppResponseDto.ImageInfo>>
    var disposeBag = DisposeBag()
    init(block: Observable<Result<GalleryAppResponseDto.ImageInfo>>) {
      self.block = block
    }
    public override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        executing(true)

        block.asObservable().bind { (some) in
            self.result = some
            self.executing(false)
            self.finish(true)
        }.disposed(by: disposeBag)

    }
}

public class GalleryAppAPIRelatedUseCase: GenericUseCase, GalleryAppAPIRelatedUseCaseProtocol {

    public override init() { super.init() }

    public var repositoryNetwork: GalleryAppNetWorkRepositoryProtocol!
    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    // Will
    // - Manage the requests qeue
    // - Call the API
    // - Manage the Cache
    // (Converting Dto entities to Model entities will be done above on the worker)
    public func imageInfo(_ request: GalleryAppRequests.ImageInfo, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppResponseDto.ImageInfo>> {
        let cacheKey = "\(#function).\(request)"

        var block: Observable<Result<GalleryAppResponseDto.ImageInfo>> {
            print("################# REQUEST #################")
            var apiObserver: Observable<GalleryAppResponseDto.ImageInfo> {
                return Observable<GalleryAppResponseDto.ImageInfo>.create { observer in
                    self.repositoryNetwork.imageInfo(request) { (result) in
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
            let cacheObserver = genericCacheObserver(GalleryAppResponseDto.ImageInfo.self,
                                                     cacheKey: cacheKey,
                                                     keyParams: [],
                                                     apiObserver: apiObserver.asSingle())

            // Handle by cache strategy
            let apiObserverResult = apiObserver.flatMap { Observable.just(Result.success($0)) }.catchError { Observable.just(Result.failure($0)) }
            let cacheObserverResult = cacheObserver.flatMap { Observable.just(Result.success($0)) }.catchError { Observable.just(Result.failure($0)) }

            switch cacheStrategy {
            case .noCacheLoad: return apiObserverResult.asObservable()
            case .cacheElseLoad: return cacheObserverResult.asObservable()
            case .cacheAndLoad: return Observable.merge(cacheObserverResult, apiObserverResult.asObservable() )
            case .cacheNoLoad: fatalError("Not safe!")
            }
        }

// Strong references. fix latter
        return Observable<Result<GalleryAppResponseDto.ImageInfo>>.create { observer in
            let networkingOperation = ImageInfoRequestOperation(block: block)
            self.operationQueue.addOperations([networkingOperation], waitUntilFinished: false)
            networkingOperation.completionBlock = {
                if networkingOperation.isCancelled {
                    return
                }
                if let result = networkingOperation.result, result != nil {
                    observer.on(.next(networkingOperation.result!))
                } else {
                    observer.on(.error(Factory.Errors.with(appCode: .notPredicted)))
                }
                observer.on(.completed)
                print("#############################################")
            }

            return Disposables.create()
        }

        /*
        var apiObserver: Observable<GalleryAppResponseDto.ImageInfo> {
            return Observable<GalleryAppResponseDto.ImageInfo>.create { observer in
                self.repositoryNetwork.imageInfo(request) { (result) in
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
        let cacheObserver = genericCacheObserver(GalleryAppResponseDto.ImageInfo.self,
                                                 cacheKey: cacheKey,
                                                 keyParams: [],
                                                 apiObserver: apiObserver.asSingle())

        // Handle by cache strategy
        let apiObserverResult = apiObserver.flatMap { Observable.just(Result.success($0)) }.catchError { Observable.just(Result.failure($0)) }
        let cacheObserverResult = cacheObserver.flatMap { Observable.just(Result.success($0)) }.catchError { Observable.just(Result.failure($0)) }

        switch cacheStrategy {
        case .noCacheLoad: return apiObserverResult.asObservable()
        case .cacheElseLoad: return cacheObserverResult.asObservable()
        case .cacheAndLoad: return Observable.merge(cacheObserverResult, apiObserverResult.asObservable() )
        case .cacheNoLoad: fatalError("Not safe!")
        }*/
    }

    // Will
    // - Call the API
    // - Manage the Cache
    // (Converting Dto entities to Model entities will be done above on the worker)
    public func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppResponseDto.Search>> {
        let cacheKey = "\(#function).\(request)"

        // API
        var apiObserver: Observable<GalleryAppResponseDto.Search> {
            return Observable<GalleryAppResponseDto.Search>.create { observer in
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
        let cacheObserver = genericCacheObserver(GalleryAppResponseDto.Search.self,
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
