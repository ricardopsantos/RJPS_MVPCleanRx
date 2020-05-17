//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import DevTools

extension AppDelegate {
    func setup(application: UIApplication) {
        AppLogger.enabled = DevTools.FeatureFlag.getFlag(.devTeam_doLogs)
        AppEnvironments.setup()
        AppLogger.log("RJPSLib Version : \(RJSLib.version)")
        AppLogger.log("Number of logins : \(AppUserDefaultsVars.incrementIntWithKey(AppConstants.Dev.numberOfLogins))")
    }
}
