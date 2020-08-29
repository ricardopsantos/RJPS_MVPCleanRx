//
//  GoodToGo
//
//  Created by Ricardo Santos on 29/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import PointFreeFunctions
import Core
//
import Domain_CarTrack

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
