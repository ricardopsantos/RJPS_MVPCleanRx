//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib_Networking
import RxSwift
//
import AppConstants
import PointFreeFunctions
import Domain
import Domain_GalleryApp
import Factory
import Core
import AppResources

public class GalleryAppMicBusinessUseCase: GenericUseCase, GalleryAppGenericBusinessUseCaseProtocol {

    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    public func download(_ request: GalleryAppModel.ImageInfo) -> Observable<UIImage> {

        return Observable<UIImage>.create { [weak self] observer in
            if let size = request.sizes.size.filter({ $0.label == "Large Square" }).last {
                let networkingOperation = DownloadImageOperation(withURLString: size.source)
                self?.operationQueue.addOperations([networkingOperation], waitUntilFinished: false)
                networkingOperation.completionBlock = {
                    if networkingOperation.isCancelled || networkingOperation.image == nil {
                        observer.on(.next(Images.notFound.image))
                    } else {
                        observer.on(.next(networkingOperation.image!))
                    }
                    observer.on(.completed)
                }
            } else {
                observer.on(.next(Images.notFound.image))
                observer.on(.completed)
            }
            return Disposables.create()

        }
    }
}

private class DownloadImageOperation: OperationBase {
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
