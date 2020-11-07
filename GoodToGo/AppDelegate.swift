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
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

import Repositories_WebAPI
import Domain_GalleryApp
import Domain_CarTrack
import RJSLibUFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    struct RemoteRoom {

    }
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

        //AlamofireTesting.doTests()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // handle any deep-link
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
}
