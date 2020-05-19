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
        DevTools.Log.enabled = DevTools.FeatureFlag.getFlag(.devTeam_doLogs)
        AppEnvironments.setup()
        DevTools.Log.log("RJPSLib Version : \(RJSLib.version)")
        DevTools.Log.log("Number of logins : \(AppUserDefaultsVars.incrementIntWithKey(AppConstants.Dev.numberOfLogins))")
    }
}
