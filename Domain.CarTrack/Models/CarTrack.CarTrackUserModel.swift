//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import Domain

public extension CarTrackAppModel {

    struct User: ModelEntityProtocol {
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

        public struct Address: ModelEntityProtocol {
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

        public struct Geo: ModelEntityProtocol {
            public let lat, lng: String

            public init() {
                self.lat = ""
                self.lng = ""
            }
        }

        public struct Company: ModelEntityProtocol {
            public let name, catchPhrase, bs: String

            public init() {
                self.name = ""
                self.catchPhrase = ""
                self.bs = ""
            }
        }
    }

}
