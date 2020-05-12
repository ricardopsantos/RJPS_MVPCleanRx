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

        case statsTotalEnabled     = "statsTotalEnabled"       // Client
        case devTeam_showToasts    = "DEV: devTeam_showToasts" // Dev team
        case devTeam_useMockedData = "DEV: Use Mock Data"      // Dev team
        case devTeam_doLogs        = "DEV: App can do logs"    // Dev team

        public var defaultValue: Bool {
            switch self {
            case .statsTotalEnabled:
                return true
            case .devTeam_showToasts:
                return DevTools.devModeIsEnabled
            case .devTeam_useMockedData:
                return DevTools.devModeIsEnabled
            case .devTeam_doLogs:
                return DevTools.devModeIsEnabled
            }
        }

        public var isTrue: Bool {
            return FeatureFlag.getFlag(self) == true
        }

        public static func getFlag(_ flagName: FeatureFlag) -> Bool {
            let defaultValue = flagName.defaultValue
            guard !DevTools.isProductionReleaseApp else {
                // If production then we need to get the default value
                return defaultValue
            }
            guard UserDefaults.standard.object(forKey: flagName.rawValue) != nil else {
                return defaultValue
            }
            return UserDefaults.standard.bool(forKey: flagName.rawValue)
        }

        public static func setFlag(_ flagName: FeatureFlag, value: Bool) {
            UserDefaults.standard.set(value, forKey: flagName.rawValue)
        }
    }
}
