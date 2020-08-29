//
//  Created by Ricardo Santos on 29/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public protocol CarTrackWorkerProtocol {
    //var networkRepository: GalleryAppWebAPIUseCaseProtocol! { get set }
    //var genericUseCase: GalleryAppGenericBusinessUseCaseProtocol! { get set }

    //func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<GalleryAppModel.Search>
    //func imageInfoZip(_ request: GalleryAppRequests.ImageInfo, cacheStrategy: CacheStrategy) -> Observable<(GalleryAppModel.ImageInfo, UIImage)>
}

public class CarTrackWorker {
    //public var networkRepository: GalleryAppWebAPIUseCaseProtocol!
    //public var genericUseCase: GalleryAppGenericBusinessUseCaseProtocol!
}

// MARK: - GalleryAppWorkerProtocol

extension CarTrackWorker: CarTrackWorkerProtocol {

}
