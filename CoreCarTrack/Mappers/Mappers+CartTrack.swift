//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import PointFreeFunctions
import BaseCore
//
import DomainCarTrack

public extension Mappers {
    struct CartTrack {
        private init() {}
    }
}

public extension CarTrackResponseDto.User {
    var toDomain: CarTrackAppModel.User? {
        return perfectMapper(inValue: self, outValue: CarTrackAppModel.User.self)
    }
}
