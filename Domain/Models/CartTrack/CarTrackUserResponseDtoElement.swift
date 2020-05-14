//
//  CarTrack.swift
//  AppDomain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import PointFreeFunctions

public extension CarTrack {

    struct CarTrackUserResponseDtoElement: ResponseDtoProtocol {
        public let id: Int
        public let name, username, email: String
        public let address: Address
        public let phone, website: String
        public let company: Company

        // MARK: - Address
        public struct Address: ResponseDtoProtocol {
            public let street, suite, city, zipcode: String
            public let geo: Geo
        }

        // MARK: - Geo
        public struct Geo: ResponseDtoProtocol {
            public let lat, lng: String
        }

        // MARK: - Company
        public struct Company: ResponseDtoProtocol {
            public let name, catchPhrase, bs: String
        }
    }
}

public extension CarTrack.CarTrackUserResponseDtoElement {
    public var toDomain: Domain.CarTrack.UserModel? {
        return perfectMapper(inValue: self, outValue: Domain.CarTrack.UserModel.self)
    }
}
