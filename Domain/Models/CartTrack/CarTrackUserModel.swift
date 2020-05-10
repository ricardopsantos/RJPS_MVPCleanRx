//
//  CarTrack.swift
//  AppDomain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension CarTrack {

    struct UserModel: Codable {
        let id: Int
        let name, username, email: String
        let address: AddressModel
        let phone, website: String
        let company: CompanyModel
    }

    struct AddressModel: Codable {
        let street, suite, city, zipcode: String
        let geo: GeoModel
    }

    struct GeoModel: Codable {
        let lat, lng: String
    }

    struct CompanyModel: Codable {
        let name, catchPhrase, bs: String
    }
}
