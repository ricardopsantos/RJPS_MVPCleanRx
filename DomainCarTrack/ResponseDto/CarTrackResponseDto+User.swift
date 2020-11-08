//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import PointFreeFunctions
import Domain

public extension CarTrackResponseDto {

    struct User: ResponseDtoProtocol {
        public let id: Int
        public let name, username, email: String
        public let address: Address
        public let phone, website: String
        public let company: Company

        public init() {
            self.id = 0
            self.name = ""
            self.username = ""
            self.email = ""
            self.address = Address()
            self.phone = ""
            self.website = ""
            self.company = Company()
        }
        
        // MARK: - Address
        public struct Address: ResponseDtoProtocol {
            public let street, suite, city, zipcode: String
            public let geo: Geo

            public init() {
                self.street = ""
                self.suite = ""
                self.city = ""
                self.zipcode = ""
                self.geo = Geo()
            }
        }

        // MARK: - Geo
        public struct Geo: ResponseDtoProtocol {
            public let lat, lng: String

            public init() {
                self.lat = ""
                self.lng = ""
            }
        }

        // MARK: - Company
        public struct Company: ResponseDtoProtocol {
            public let name, catchPhrase, bs: String

            public init() {
                self.name = ""
                self.catchPhrase = ""
                self.bs = ""
            }
        }
    }
}
