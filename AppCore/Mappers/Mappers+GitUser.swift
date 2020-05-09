//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import AppDomain

//
// The Brain Of The App
//

public extension Mappers {
    struct GitUser {
        private init() {}
        static func toViewModelList(_ list: [GitHub.UserResponseDto]) -> [GitHub.UserViewModel] {
            var result: [GitHub.UserViewModel] = []
            for element in list {
                result.append(GitHub.UserViewModel(some: element))
            }
            return result
        }
    }
}
