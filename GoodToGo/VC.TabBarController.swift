//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import Swinject
//
import Domain
import DevTools

extension VC {

    class TabBarController: UITabBarController {

        //let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()
        override func loadView() {
            super.loadView()
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            let mvpSample1 = createControllers(tabName: "MVP", vc: AppDelegate.shared.container.resolve(V.MVPSampleView_View.self)!)
            let mvpSample2 = createControllers(tabName: "MVP.Rx", vc: AppDelegate.shared.container.resolve(V.MVPSampleRxView_View.self)!)
            let mvpSample3 = createControllers(tabName: "MVP.Rx.Table", vc: AppDelegate.shared.container.resolve(V.MVPSampleTableView_View.self)!)

            let mvpGitUser   = createControllers(tabName: "GitUser", vc: AppDelegate.shared.container.resolve(V.SearchUser_View.self)!)
            let mvpBliss     = createControllers(tabName: "Bliss", vc: AppDelegate.shared.container.resolve(V.BlissRoot_View.self)!)
            let vipCarTrack1 = createControllers(tabName: "CarTrack", vc: VC.CarTrackLoginViewController(presentationStyle: .modal))
            let vipCarTrack2 = createControllers(tabName: "CarTrack", vc: VC.CartTrackMapViewController(presentationStyle: .modal))

            let vcRx = createControllers(tabName: "RxTesting", vc: RxTesting())

            let vipTemplate = createControllers(tabName: "Template", vc: VC.___VARIABLE_sceneName___ViewController(presentationStyle: .modal))
            let vipDebug    = createControllers(tabName: "DebugView", vc: VC.DebugViewController(presentationStyle: .modal))

            var viewControllersList: [UIViewController] = []
            if DevTools.FeatureFlag.showScene_bliss.isTrue { viewControllersList.append(mvpBliss) }
            if DevTools.FeatureFlag.showScene_carTrack.isTrue { viewControllersList.append(vipCarTrack1) }
            if DevTools.FeatureFlag.showShene_gitHub.isTrue { viewControllersList.append(mvpGitUser) }
            if DevTools.FeatureFlag.showScene_vipTemplate.isTrue { viewControllersList.append(vipTemplate) }
            if DevTools.FeatureFlag.showScene_rxTests.isTrue { viewControllersList.append(vcRx) }

            viewControllers = [VC.CategoriesPickerViewController(presentationStyle: .modal)] + viewControllersList + [vipDebug] + [vipCarTrack2]
            
        }

        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController {
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
