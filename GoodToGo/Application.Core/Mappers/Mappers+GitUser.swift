//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//
// The Brain Of The App
//

extension Mappers {
    struct GitUser {
        private init() {}
        static func toViewModelList(_ list:[E.GitHubUser]) -> [VM.GitHubUser] {
            var result : [VM.GitHubUser] = []
            for element in list {
                result.append(VM.GitHubUser(some: element))
            }
            return result
        }
    }
}


