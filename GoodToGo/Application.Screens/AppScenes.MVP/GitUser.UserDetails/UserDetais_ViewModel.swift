//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
