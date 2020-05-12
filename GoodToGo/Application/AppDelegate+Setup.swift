//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions

extension AppDelegate {
    func setup(application: UIApplication) {
        AppEnvironments.setup()
        AppLogger.enabled = AppCan.Logs.doLogs
        AppLogger.log("Number of logins : \(AppUserDefaultsVars.incrementIntWithKey(AppConstants.Dev.numberOfLogins))")
      //  AppLogger.log("RJPSLib Version : \(RJSLib.version)")
    }
}
