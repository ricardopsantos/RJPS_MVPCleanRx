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

        case devTeam_showToasts     = "Show toast if error happens"
        case devTeam_useMockedData  = "Use Mock Data"
        case devTeam_doLogs         = "App can do logs"
        case devTeam_logDeinit      = "Log on deinit event"
        case devTeam_showStats      = "Show Stats View"

        case devTeam_showSheme_bliss       = "Shene Enabled: Bliss"
        case devTeam_showSheme_rxTests     = "Shene Enabled: RxTests"
        case devTeam_showSheme_carTrack    = "Shene Enabled: CarTrack"
        case devTeam_showSheme_gitHub      = "Shene Enabled: GitHub"
        case devTeam_showSheme_vipTemplate = "Shene Enabled: VIP Template"

        public var defaultValue: Bool {
            switch self {
            case .devTeam_showToasts: return DevTools.devModeIsEnabled
            case .devTeam_useMockedData: return false
            case .devTeam_doLogs: return DevTools.devModeIsEnabled
            case .devTeam_logDeinit: return false
            case .devTeam_showStats: return DevTools.devModeIsEnabled
            case .devTeam_showSheme_bliss: return true

            case .devTeam_showSheme_rxTests: return true
            case .devTeam_showSheme_carTrack: return true
            case .devTeam_showSheme_gitHub: return true
            case .devTeam_showSheme_vipTemplate: return true
            }
        }

        public var isVisible: Bool {
             switch self {
             case .devTeam_showToasts:            return true
             case .devTeam_useMockedData:         return true
             case .devTeam_doLogs:                return true
             case .devTeam_logDeinit:             return true
             case .devTeam_showStats:             return true
             case .devTeam_showSheme_bliss:       return true
             case .devTeam_showSheme_rxTests:     return true
             case .devTeam_showSheme_carTrack:    return true
             case .devTeam_showSheme_gitHub:      return true
             case .devTeam_showSheme_vipTemplate: return true
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
