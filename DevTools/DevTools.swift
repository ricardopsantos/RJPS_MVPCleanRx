//
//  DevTools.swift
//  DevTools
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import ToastSwiftFramework
import RJPSLib
import PointFreeFunctions

public struct DevTools {
    private init() { }

    private static var appMode: String? {
        return (Bundle.main.infoDictionary?["BuildConfig_AppMode"] as? String)?.replacingOccurrences(of: "\\", with: "")
    }

    public static var isProductionApp = appMode == "Debug.Prod"
    public static var isQualityApp    = appMode == "Debug.QA"
    public static var isStagingApp    = appMode == "Debug.Dev"

    public static var environmentsDescription: String {
        let target: String = DevTools.onDebug ? "debug" : "release"
        if DevTools.isProductionApp { return "Prod \(target)" }
        if DevTools.isQualityApp { return "QA \(target)" }
        if DevTools.isStagingApp { return "Dev \(target)" }
        return ""
    }

    public static var onRealDevice: Bool {
        return !onSimulator
    }

    public static var onSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    public static var onDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    public static var onRelease: Bool {
        return !onDebug
    }

    public static var isQualityReleaseApp: Bool {
        // Should return true, if is a Quality Team app
        return isQualityApp && onRelease
    }

    public static var isProductionReleaseApp: Bool {
        // Should return true, if is a Production app
        return isProductionApp && onRelease
    }

    public static var devModeIsEnabled: Bool {
        if isProductionReleaseApp {
            return false
        }
        return onDebug || onSimulator
     }

    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        return topController
    }
}

extension DevTools {

    /// if [searchForErrors] = true, the message will be scaned in order to decide if its an error and should present a different toast specific for error
    public static func makeToast(_ message: String, isError: Bool = false, function: String = #function, file: String = #file, line: Int = #line) {
        guard !DevTools.isProductionReleaseApp else { return } //If production bail out immediately
        guard DevTools.devModeIsEnabled else { return } // Not dev mode? bail out immediately

        guard DevTools.FeatureFlag.getFlag(.devTeam_showToasts) else {
            // Disabled toast
            return
        }

        func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return topViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller
        }

        // Delay because sometimes we are changing screen, and the toast would be lost..
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var style = ToastStyle()
            style.cornerRadius = 5

            let messageFinal = "\(message)\n\n@\(whereAmIDynamic(function: "\(function)", file: "\(file)", line: line, short: true))"
            if isError {
                style.backgroundColor = UIColor.red.withAlphaComponent(0.9)
                style.messageColor = .white
                topViewController()?.view.makeToast(messageFinal, duration: 10.0, position: .top, style: style)
            } else {
                var style = ToastStyle()
                style.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
                style.messageColor = .white
                topViewController()?.view.makeToast(messageFinal, duration: 3.0, position: .top, style: style)
            }
        }
    }
}
