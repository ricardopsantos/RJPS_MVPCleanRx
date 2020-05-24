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
        DevTools.Log.enabled = DevTools.FeatureFlag.appLogsEnabled.isTrue
        AppEnvironments.setup()
        DeepLinks.Parsers.NotificationParser.shared.setup()
        DeepLinks.Parsers.DeeplinkParser.shared.setup()
        DeepLinks.Parsers.ShortcutParser.shared.setup()
        DevTools.Log.message("RJPSLib Version : \(RJSLib.version)\nNumber of logins : \(AppUserDefaultsVars.incrementIntWithKey(AppConstants.Dev.numberOfLogins))")
    }
}
