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
import NSLoggerSwift
//
import AppConstants
import PointFreeFunctions
import DevTools

extension AppDelegate {
    func setup(application: UIApplication) {

        if DevTools.FeatureFlag.appLogsEnabled.isTrue {
            // Enable logs
            DevTools.Log.enabled = true
        }

        if DevTools.FeatureFlag.appLogsEnabled.isTrue && DevTools.FeatureFlag.nsLogger.isTrue {
            // https://github.com/fpillet/NSLogger#using-nslogger-on-a-shared-network
            LoggerSetupBonjourForBuildUser()
        }

        AppEnvironments.setup()
        DevTools.Log.message("RJPSLib Version : \(RJSLib.version)\nNumber of logins : \(AppUserDefaultsVars.incrementIntWithKey(AppConstants.Dev.numberOfLogins))")
    }
}
