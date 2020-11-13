//
//  GoodToGo
//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJSLibUFNetworking
import RxSwift
//

/**
Use case Protocol for things related with __app generic business__
 */

public protocol GalleryAppGenericBusinessUseCaseProtocol: class {
    func download(_ request: GalleryAppModel.ImageInfo) -> Observable<UIImage>
}
