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

//public typealias GalleryAppAPIUseCaseCompletionHandler = (_ result: Result<[GalleryApp.SampleModel1Dto]>) -> Void

public protocol CarTrackAPIRelated_UseCaseProtocol: class {

    /// returns Result<T> with completion handler
    //func getUserDetailV1(completionHandler: @escaping GalleryAppAPIUseCaseCompletionHandler)

    /// returns a Observer
    //func getUserDetailV2(cacheStrategy: CacheStrategy) -> Observable<[GalleryApp.SampleModel1Dto]>

    /// Mix of the Observer version and the Result<T>
    func getUserDetailV3(cacheStrategy: CacheStrategy) -> Observable<Result<[GalleryApp.SampleModel1Dto]>>
}
