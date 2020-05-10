//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
        public func pretyDescription() -> String {
            if let name = name {
                return "\(name)"
            }
            return ""
        }
    }
}
