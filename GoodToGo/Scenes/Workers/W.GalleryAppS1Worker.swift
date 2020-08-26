//
//  Created by Ricardo Santos on 26/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
//
import RxSwift
import RxCocoa
import AppConstants
import DevTools
import Extensions
import PointFreeFunctions
import RJPSLib_Networking
import Factory
//
import Domain
import Domain_GalleryApp

public class OperationBase: Operation {
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

public class DownloadImageOperation: OperationBase {
    let urlString: String
    var image: UIImage?
    init(withURLString urlString: String) {
        self.urlString = urlString
    }
    public override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        executing(true)
        RJS_BasicNetworkClient.downloadImageFrom(urlString, caching: .fileSystem) { (image) in
            self.image = image
            self.executing(false)
            self.finish(true)
        }
    }
}

public protocol GalleryAppWorkerProtocol {
    var api: GalleryAppAPIRelatedUseCaseProtocol! { get set }
    var genericUseCase: GalleryAppGenericBusinessUseCaseProtocol! { get set }

    func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.Search>>
    func imageInfo(_ request: GalleryAppRequests.ImageInfo, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.ImageInfo>>
    func download(_ request: GalleryAppModel.ImageInfo, completion: @escaping (UIImage?) -> Void)
}

public class GalleryAppWorker: GalleryAppWorkerProtocol {

    public var api: GalleryAppAPIRelatedUseCaseProtocol!
    public var genericUseCase: GalleryAppGenericBusinessUseCaseProtocol!

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    public func download(_ request: GalleryAppModel.ImageInfo, completion:@escaping (UIImage?) -> Void) {
        if let size = request.sizes.size.filter({ $0.label == "Large Square" }).last {
            let networkingOperation = DownloadImageOperation(withURLString: size.source)
            operationQueue.addOperations([networkingOperation], waitUntilFinished: false)
            networkingOperation.completionBlock = {
                if networkingOperation.isCancelled {
                    completion(nil)
                    return
                }
                print("#############################################")
                print("received: \(networkingOperation.urlString)")
                completion(networkingOperation.image)
            }
        } else {
            completion(nil)
        }
    }

    public func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.Search>> {
        // Map Dto -> Model
        return api.search(request, cacheStrategy: cacheStrategy)
            .flatMap { (result) -> Observable<Result<GalleryAppModel.Search>> in
            switch result {
            case .success(let some):
                if let domain = some.toDomain {
                    return Observable.just(Result.success(domain))
                } else {
                    return Observable.just(Result.failure(Factory.Errors.with(appCode: .parsingError)))
                }
            case .failure(let error):
                return Observable.just(Result.failure(error))
            }
        }
    }

    public func imageInfo(_ request: GalleryAppRequests.ImageInfo, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.ImageInfo>> {
        // Map Dto -> Model
        return api.imageInfo(request, cacheStrategy: cacheStrategy)
            .flatMap { (result) -> Observable<Result<GalleryAppModel.ImageInfo>> in
            switch result {
            case .success(let some):
                if let domain = some.toDomain {
                    return Observable.just(Result.success(domain))
                } else {
                    return Observable.just(Result.failure(Factory.Errors.with(appCode: .parsingError)))
                }
            case .failure(let error):
                return Observable.just(Result.failure(error))
            }
        }
    }
}
