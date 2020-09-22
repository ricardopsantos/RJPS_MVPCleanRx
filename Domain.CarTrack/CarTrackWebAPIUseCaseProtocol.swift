//
//  GoodToGo
//
//  Created by Ricardo Santos
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

public protocol CarTrackWebAPIUseCaseProtocol: class {

    func getUsers(request: CarTrackRequests.GetUsers, cacheStrategy: CacheStrategy) -> Observable<[CarTrackResponseDto.User]>

}
