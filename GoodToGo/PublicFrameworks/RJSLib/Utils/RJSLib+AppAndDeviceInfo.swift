//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLib {
    
    public struct AppAndDeviceInfo {
        private init() {}

        public static func appIsOnBackground() -> Bool {
            let appState = UIApplication.shared.applicationState
            if(appState == .background || appState == .inactive) {
                // Inactive - Quando temo o menu das pushnotifications aberto (por exemplo)
                return true
            }
            return false
        }
        
        // Just for iPhone simulador
        public static func isiPhoneSimulator () -> Bool {
            #if targetEnvironment(simulator) && os(iOS)
            return true
            #else
            return false
            #endif
        }
        
        // For any simulator
        public static func isSimulator () -> Bool {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }
        
        static func isXDevide() -> Bool {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136: _ = 1// iPhone 5 or 5S or 5C
                case 1334: _ = 1 // iPhone 6/6S/7/8
                case 1920, 2208: _ = 1 // iPhone 6+/6S+/7+/8+
                case 2436: // iPhone X, XS
                    return true
                case 2688: // iPhone XS Max
                    return true
                case 1792: // iPhone XR
                    return true
                default:
                    RJSLib.Logs.DLog("Unknown")
                }
                return false
            }
            return false
        }
        
        public static func iPadDevice () -> Bool {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
        
        public static func iPhoneDevice () -> Bool {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
        
        public static func deviceIsInLowPower () -> Bool {
            let processInfo = ProcessInfo.processInfo
            if #available(iOS 9.0, *) {
                if processInfo.isLowPowerModeEnabled {
                    return true
                }
            }
            return false
        }
        
        public static func deviceInfo() -> [String:String] {
            var result = [String:String]()
            result["deviceID"]          = "\(deviceID())"
            result["model"]             = "\(UIDevice.current.model)"
            result["systemVersion"]     = "\(UIDevice.current.systemVersion)"
            result["OperatingSystem"]   = "\(ProcessInfo().operatingSystemVersionString)"
            return result
        }
        
        public static func deviceID() -> String {
            return UIDevice.current.identifierForVendor!.uuidString
        }
        
    }

}






