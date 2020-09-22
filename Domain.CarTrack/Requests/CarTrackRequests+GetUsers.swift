//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// Encapsulate API Requests
public extension CarTrackRequests {
    struct GetUsers {
        public let userName: String

        public init(userName: String) {
            self.userName = userName
        }
    }
}
