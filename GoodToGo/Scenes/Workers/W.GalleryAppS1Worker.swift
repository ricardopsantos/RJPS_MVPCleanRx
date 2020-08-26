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

public protocol GalleryAppWorkerProtocol {
    var api: GalleryAppAPIRelatedUseCaseProtocol! { get set }
    var genericUseCase: GalleryAppGenericBusinessUseCaseProtocol! { get set }

    func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.Availability>>

}

public class GalleryAppWorker: GalleryAppWorkerProtocol {
    public var api: GalleryAppAPIRelatedUseCaseProtocol!
    public var genericUseCase: GalleryAppGenericBusinessUseCaseProtocol!

    public func search(_ request: GalleryAppRequests.Search, cacheStrategy: CacheStrategy) -> Observable<Result<GalleryAppModel.Availability>> {
        // Map Dto -> Model
        return api.search(request, cacheStrategy: cacheStrategy)
            .flatMap { (result) -> Observable<Result<GalleryAppModel.Availability>> in
            switch result {
            case .success(let some):
                if let domain = some.toDomain {
                    return Observable.just(Result.success(domain))
                } else {
                    return Observable.just(Result.failure(Factory.Errors.with(appCode: .noInternet)))
                }
            case .failure(let error):
                return Observable.just(Result.failure(error))
            }
        }
    }
}
