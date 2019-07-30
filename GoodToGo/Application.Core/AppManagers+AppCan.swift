//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension AppManagers {
    
    struct AppCan {
        private init() {}
        static var pickLanguage = false
        
        struct Logs {
            private init() {}
            static var doLogs   = AppEnvironments.isDev()
            static var requests = AppEnvironments.isDev()
        }
    }
}
