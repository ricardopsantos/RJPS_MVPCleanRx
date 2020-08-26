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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    public var reachabilityService: ReachabilityService? = DevTools.reachabilityService
    let disposeBag = DisposeBag()

    // Where we have all the dependencies
    let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()

    var acc = 0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let request = GalleryAppRequests.Search(tags: ["cat", "dog"])
        let observable = container.resolve(AppProtocols.galleryAppAPI_UseCase)?.search(request, cacheStrategy: .noCacheLoad).asObservable()
        observable?.bind(onNext: { (some) in
            print(some)
            }).disposed(by: disposeBag)

        if CommandLine.arguments.contains(AppConstants.Testing.CommandLineArguments.deleteUserData) {
            //resetAllData = true
        }

        setup(application: application)
        self.window?.rootViewController = VC.TabBarController()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // handle any deeplink
        DeepLinkManager.shared.checkDeepLinksToHandle()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
}
