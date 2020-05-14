//
//  CarTrack.swift
//  AppCore
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import PointFreeFunctions
//
import Domain

public extension Mappers {
    struct CarTrack {
        static func userDtoToDomain(_ dto: CarTrackUserResponseDtoElement) -> CarTrackUserModel? {
            return perfectMapper(inValue: dto, outValue: CarTrackUserModel.self)
        }
    }
}
