//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxSwift
import RxCocoa
import RJSLibUFStorage
//
import AppResources
import BaseUI
import AppTheme
import BaseConstants
import Extensions
import DevTools
import PointFreeFunctions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    public var reachabilityService: ReachabilityService? = DevTools.reachabilityService

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if CommandLine.arguments.contains(AppConstants.Testing.CommandLineArguments.deleteUserData) {
            //resetAllData = true
        }

        setup(application: application)
        self.window?.rootViewController = VC.TabBarController()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // handle any deep-link
    }

    func applicationWillTerminate(_ application: UIApplication) {
        RJS_DataModelManager.saveContext()
    }
}
