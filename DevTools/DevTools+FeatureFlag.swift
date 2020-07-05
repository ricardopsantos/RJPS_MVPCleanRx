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

        case showToastsOnErrors        = "Show toast if error happens"
        case devTeam_useMockedData     = "Use Mock Data"
        case showDebugStatsViewOnView  = "Show Stats View"
        case appLogsEnabled            = "Logs: enabled"
        case logDeInitEvent            = "Logs: log deinit event"
        case nsLogger                  = "If [true] log to console, else to NSLogger"

        case showScene_rxTests     = "Scene Enabled: RxTests"
        case showScene_VisionBox   = "Scene Enabled: VisionBox "

        case showScene_vipTemplate = "Scene Enabled: VIP Template"

        // Default value
        public var defaultValue: Bool {
            switch self {
            case .showToastsOnErrors:       return DevTools.devModeIsEnabled
            case .devTeam_useMockedData:    return false
            case .appLogsEnabled:           return DevTools.devModeIsEnabled
            case .logDeInitEvent:           return false
            case .showDebugStatsViewOnView: return DevTools.devModeIsEnabled
            case .nsLogger:                 return false

            case .showScene_rxTests:     return false
            case .showScene_vipTemplate: return false
            case .showScene_VisionBox:   return true
            }
        }

        // If FF is visbible on debug screen
        public var isVisible: Bool {
             switch self {
             case .showToastsOnErrors:       return true
             case .devTeam_useMockedData:    return true
             case .appLogsEnabled:           return true
             case .nsLogger:                 return true
             case .logDeInitEvent:           return true
             case .showDebugStatsViewOnView: return true
             case .showScene_rxTests:        return true
             case .showScene_vipTemplate:    return true
             case .showScene_VisionBox:      return true
            }
        }

        public var isTrue: Bool {
            return FeatureFlag.getFlag(self)
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
