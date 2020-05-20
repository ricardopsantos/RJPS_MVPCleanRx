//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Swinject
import Domain

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

            let mvpGitUser = createControllers(tabName: "GitUser", vc: AppDelegate.shared.container.resolve(V.SearchUser_View.self)!)
            let mvpBliss = createControllers(tabName: "Bliss", vc: AppDelegate.shared.container.resolve(V.BlissRoot_View.self)!)

            let vcRx = createControllers(tabName: "RxTesting", vc: RxTesting())

            let vipTemplate = createControllers(tabName: "Template", vc: VC.___VARIABLE_sceneName___ViewController())
            let vipDebug    = createControllers(tabName: "DebugView", vc: VC.DebugViewController())
            let vipCarTrack = createControllers(tabName: "CarTrack", vc: VC.CarTrackLoginViewController())

            viewControllers = [vipDebug, vipTemplate, vipCarTrack, mvpBliss]
            
        }

        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController {
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
