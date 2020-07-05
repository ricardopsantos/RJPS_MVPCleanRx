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

            let vipVisionBox = createControllers(tabName: "VisionBox", vc: VC.CategoriesPickerViewController(presentationStyle: .modal))

            let vcRx = createControllers(tabName: "RxTesting", vc: RxTesting())

            let vipTemplate = createControllers(tabName: "Template", vc: VC.___VARIABLE_sceneName___ViewController(presentationStyle: .modal))
            let vipDebug    = createControllers(tabName: "DebugView", vc: VC.DebugViewController(presentationStyle: .modal))

            var viewControllersList: [UIViewController] = []
            if DevTools.FeatureFlag.showScene_VisionBox.isTrue { viewControllersList.append(vipVisionBox) }
            if DevTools.FeatureFlag.showScene_vipTemplate.isTrue { viewControllersList.append(vipTemplate) }
            if DevTools.FeatureFlag.showScene_rxTests.isTrue { viewControllersList.append(vcRx) }

            viewControllers = viewControllersList + [vipDebug]
            
        }

        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController {
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
