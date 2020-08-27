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

    private lazy var imageInfoQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    // Will
    // - Manage the requests queue
    // - Call the API
    // - Manage the Cache
    // (Converting Dto entities to Model entities will be done above on the worker)
    public func imageInfo(_ request: GalleryAppRequests.ImageInfo, cacheStrategy: CacheStrategy) -> Observable<GalleryAppResponseDto.ImageInfo> {
        let cacheKey = "\(#function).\(request)"

        var block: Observable<GalleryAppResponseDto.ImageInfo> {
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

            switch cacheStrategy {
            case .noCacheLoad: return apiObserver.asObservable()
            case .cacheElseLoad: return cacheObserver.asObservable()
            case .cacheAndLoad: return Observable.merge(cacheObserver, apiObserver.asObservable() )
            case .cacheNoLoad: fatalError("Not safe!")
            }
        }

// Strong references. fix latter
        return Observable<GalleryAppResponseDto.ImageInfo>.create { observer in
            let networkingOperation = ImageInfoRequestOperation(block: block)
            self.imageInfoQueue.addOperations([networkingOperation], waitUntilFinished: false)
            networkingOperation.completionBlock = {
                if networkingOperation.isCancelled {
                    return
                }
                if networkingOperation.result != nil {
                    observer.on(.next(networkingOperation.result!))
                } else {
                    observer.on(.error(Factory.Errors.with(appCode: .notPredicted)))
                }
                observer.on(.completed)
            }

            return Disposables.create()
        }

    }

    // Will
    // - Call the API
    // - Manage the Cache
    // (Converting Dto entities to Model entities will be done above on the worker)
    public func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<GalleryAppResponseDto.Search> {
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

        // Handle by cache strategy

        switch cacheStrategy {
        case .noCacheLoad: return apiObserver.asObservable()
        case .cacheElseLoad: return cacheObserver.asObservable()
        case .cacheAndLoad: return Observable.merge(cacheObserver, apiObserver.asObservable() )
        case .cacheNoLoad: fatalError("Not safe!")
        }
    }
}

private class ImageInfoRequestOperation: OperationBase {
    var result: GalleryAppResponseDto.ImageInfo?
    private var block: Observable<GalleryAppResponseDto.ImageInfo>
    var disposeBag = DisposeBag()
    init(block: Observable<GalleryAppResponseDto.ImageInfo>) {
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
