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
__Web API__ Requests Protocol
 */

public typealias GalleryAppResponseSearchCompletionHandler = (_ result: Result<RJS_SimpleNetworkClientResponse<GalleryAppResponseDto.Search>>) -> Void
public typealias GalleryAppResponseImageInfoCompletionHandler = (_ result: Result<RJS_SimpleNetworkClientResponse<GalleryAppResponseDto.ImageInfo>>) -> Void

public protocol GalleryAppNetWorkRepositoryProtocol: class {

    func search(_ request: GalleryAppRequests.Search, completionHandler: @escaping GalleryAppResponseSearchCompletionHandler)

    func imageInfo(_ request: GalleryAppRequests.ImageInfo, completionHandler: @escaping GalleryAppResponseImageInfoCompletionHandler)

}
