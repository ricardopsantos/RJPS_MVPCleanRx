//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//
import Domain

public extension VM {
    struct UserDetais {
        public let user: GitHub.UserResponseDto
        public let friends: [GitHub.UserResponseDto]
    }
}
