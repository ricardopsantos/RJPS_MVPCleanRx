//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib_Networking
//
import AppConstants
import PointFreeFunctions
import Domain
import Domain_GalleryApp
import Factory
import Core

public class GalleryAppMicBusinessUseCase: GenericUseCase, GalleryAppGenericBusinessUseCaseProtocol {

    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

}
