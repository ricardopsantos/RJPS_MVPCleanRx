//
//  FeatureFlag.swift
//  DevTools
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

public extension DevTools {
    enum FeatureFlag: String, CaseIterable {

        case devTeam_showToasts     = "DEV: devTeam_showToasts" // Dev team
        case devTeam_useMockedData  = "DEV: Use Mock Data"      // Dev team
        case devTeam_doLogs         = "DEV: App can do logs"    // Dev team
        case devTeam_autoInsertPass = "DEV: CarTrack - AutoInsertPassword"  // Dev team

        public var defaultValue: Bool {
            switch self {
            case .devTeam_showToasts:
                return DevTools.devModeIsEnabled
            case .devTeam_useMockedData:
                return false
            case .devTeam_doLogs:
                return DevTools.devModeIsEnabled
            case .devTeam_autoInsertPass:
                return false
            }
        }

        public var isTrue: Bool {
            let value = FeatureFlag.getFlag(self) == true
            return value
        }

        public static func getFlag(_ flagName: FeatureFlag) -> Bool {
            let defaultValue = flagName.defaultValue
            guard !DevTools.isProductionReleaseApp else {
                // If production then we need to get the default value
                return defaultValue
            }

            if RJSLib.Storages.NSUserDefaults.existsWith(flagName.rawValue) {
                if let value = RJSLib.Storages.NSUserDefaults.getWith(flagName.rawValue) {
                    return "\(value)" == "\(true)"
                }
            }
            return defaultValue

        }

        public static func setFlag(_ flagName: FeatureFlag, value: Bool) {
            RJSLib.Storages.NSUserDefaults.save("\(value)" as AnyObject, key: flagName.rawValue)
        }
    }
}
