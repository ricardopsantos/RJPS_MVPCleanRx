//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Networking
//

/**
Use case Protocol for things related with __app generic business__
 */

public typealias GalleryAppGenericBusinessUseCaseProtocolCompletionHandler = (_ result: Result<Bool>) -> ()

public protocol GalleryAppGenericBusinessUseCaseProtocol: class {
    //func validate(user: String, password: String, completionHandler: @escaping GalleryAppGenericBusinessUseCaseProtocolCompletionHandler)
}
