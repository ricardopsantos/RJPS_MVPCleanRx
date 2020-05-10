//
//  CarTrack.swift
//  AppDomain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension CarTrack {
    // MARK: - CarTrackUserResponseDtoElement
    struct CarTrackUserResponseDtoElement: Codable {
        let id: Int
        let name, username, email: String
        let address: Address
        let phone, website: String
        let company: Company
    }

    // MARK: - Address
    struct Address: Codable {
        let street, suite, city, zipcode: String
        let geo: Geo
    }

    // MARK: - Geo
    struct Geo: Codable {
        let lat, lng: String
    }

    // MARK: - Company
    struct Company: Codable {
        let name, catchPhrase, bs: String
    }
}
