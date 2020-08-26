//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Networking
import RxSwift
//
import Domain

/**
Use case Protocol for things related with the Web API. (Its not the API Protocol)
 */

public protocol GalleryAppAPIRelatedUseCaseProtocol: class {

    /// Mix of the Observer version and the Result<T>
    func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.Availability>>
}
