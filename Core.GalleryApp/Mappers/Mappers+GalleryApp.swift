//
//  Created by Ricardo Santos on 26/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import PointFreeFunctions
import Core
//
import Domain_GalleryApp

public extension Mappers {
    struct GalleryApp {
        private init() {}
    }
}

public extension GalleryAppResponseDto.Availability {
    var toDomain: GalleryAppModel.Availability? {
        return perfectMapper(inValue: self, outValue: GalleryAppModel.Availability.self)
    }
}
