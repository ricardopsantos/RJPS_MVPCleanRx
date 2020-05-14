//
//  CarTrack.swift
//  AppDomain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension CarTrack {

    struct UserModel: ModelEntityProtocol {
        public let id: Int
        public let name, username, email: String
        public let address: AddressModel
        public let phone, website: String
        public let company: CompanyModel

        public struct AddressModel: ModelEntityProtocol {
            public let street, suite, city, zipcode: String
            public let geo: GeoModel
        }

        public struct GeoModel: ModelEntityProtocol {
            public let lat, lng: String
        }

        public struct CompanyModel: ModelEntityProtocol {
            public let name, catchPhrase, bs: String
        }
    }

}
