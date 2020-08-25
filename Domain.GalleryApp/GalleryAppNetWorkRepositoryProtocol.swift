//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib_Networking
//

/**
Web API Requests Protocol
 */

public typealias GalleryAppNetWorkRepositoryCompletionHandler = (_ result: Result<RJS_SimpleNetworkClientResponse<[GalleryApp.SampleModel1Dto]>>) -> Void

public protocol GalleryAppNetWorkRepositoryProtocol: class {
    func userDetails(completionHandler: @escaping GalleryAppNetWorkRepositoryCompletionHandler)
}
