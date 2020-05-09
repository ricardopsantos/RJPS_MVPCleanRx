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

extension Mappers {
    struct GitUser {
        private init() {}
        static func toViewModelList(_ list: [GitHubUserResponseDto]) -> [GitHubUserViewModel] {
            var result: [GitHubUserViewModel] = []
            for element in list {
                result.append(GitHubUserViewModel(some: element))
            }
            return result
        }
    }
}
