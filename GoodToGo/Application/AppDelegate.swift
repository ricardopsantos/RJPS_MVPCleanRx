//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
import Swinject
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    public var reachabilityService: ReachabilityService? = try! DefaultReachabilityService() // try! is only for simplicity sake

    // Where we have all the dependencies
    let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if CommandLine.arguments.contains(AppConstants.Testing.CommandLineArguments.deleteUserData) {
            //resetAllData = true
        }
        
        setup(application: application)
        self.window?.rootViewController = VC.TabBarController()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
}

