//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension AppConstants {
    private init() {}

    enum AppMode: Int {
        case prod
        case qa
        case dev
    }
}
