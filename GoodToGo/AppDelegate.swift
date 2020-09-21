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
import Swinject
import RJPSLib_Base
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

import Domain_GalleryApp
import Domain_CarTrack
import RJPSLib_Networking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    public var reachabilityService: ReachabilityService? = DevTools.reachabilityService

    // Where we have all the dependencies
    var disposeBag = DisposeBag()

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
        saveContext()
    }
}
