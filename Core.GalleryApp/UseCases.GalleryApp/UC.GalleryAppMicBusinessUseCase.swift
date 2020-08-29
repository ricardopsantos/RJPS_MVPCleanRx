//
//  GoodToGo
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

public class GalleryAppMiscBusinessUseCase: GenericUseCase, GalleryAppGenericBusinessUseCaseProtocol {

    public override init() { super.init() }

    public var hotCacheRepository: HotCacheRepositoryProtocol!
    public var genericLocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    public func download(_ request: GalleryAppModel.ImageInfo) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            if let size = request.sizes.size.filter({ $0.label == "Large Square" }).last {
                let operation = DownloadImageOperation(withURLString: size.source)
                OperationQueueManager.shared.add(operation)
                operation.completionBlock = {
                    if operation.isCancelled {
                        observer.on(.next(Images.notFound.image))
                    } else {
                        observer.on(.next(operation.image))
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

private class DownloadImageOperation: OperationBase, AppUtilsProtocol {
    let urlString: String
    var image: UIImage!
    init(withURLString urlString: String) {
        self.urlString = urlString
    }
    public override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        executing(true)

        downloadImage(imageURL: urlString, onFail: Images.notFound.image) { (image) in
            self.image = image!
            self.executing(false)
            self.finish(true)
        }
    }
}
