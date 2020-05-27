//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension GitHub {
    struct UserViewModel {
        private init() {}
        public var name: String!
        public init(some: UserResponseDto) {
            name = some.name ?? ""
        }
        public func prettyDescription() -> String {
            if let name = name {
                return "\(name)"
            }
            return ""
        }
    }
}
