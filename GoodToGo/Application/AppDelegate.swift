//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Swinject
import RJPSLib
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared : AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    // Where we have all the dependencies
    let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if CommandLine.arguments.contains(AppConstants_UITests.Misc.CommandLineArguments.deleteUserData) {
            //resetAllData = true
        }
        
        appPrepare(application: application)
        
        self.window?.rootViewController = V.TabBarController()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        AppGlobal.saveContext()
    }

}


