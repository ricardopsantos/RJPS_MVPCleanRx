//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Swinject

extension AppDelegate {
    func appPrepare(application: UIApplication) {
        AppEnvironments.autoSet()
        AppLogger.log("Number of logins : \(AppUserDefaultsVars.incrementIntWithKey(AppConstants.Dev.numberOfLogins))")
    }
}
