//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import UIBase
import DevTools
import UICarTrack
import UIGalleryApp

extension VC {

    class TabBarController: UITabBarController {

        override func loadView() {
            super.loadView()
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            let vipCarTrackApp = createControllers(tabName: "VIP.CarTrack", vc: UICarTrackEntryPoint.instance())
            let vipGalleryApp  = createControllers(tabName: "VIP.Gallery", vc: UIGalleryAppEntryPoint.instance())

            // TESTING / DEBUG/ TEMPLATES
            let vipTemplate = createControllers(tabName: "VIP.Template", vc: VC.___VARIABLE_sceneName___ViewController())
            let vipDebug    = createControllers(tabName: "DevScreen", vc: VC.DebugViewController())

            var viewControllersList: [UIViewController] = []
            if DevTools.FeatureFlag.showScene_gallery.isTrue { viewControllersList.append(vipGalleryApp) }
            if DevTools.FeatureFlag.showScene_carTrack.isTrue { viewControllersList.append(vipCarTrackApp) }
            if DevTools.FeatureFlag.showScene_vipTemplate.isTrue { viewControllersList.append(vipTemplate) }

            viewControllers = [vipDebug] + viewControllersList
            
        }

        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController {
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            if #available(iOS 13.0, *) {
                tabVC.tabBarItem.image = UIImage(systemName: "heart")
            } else {
                DevTools.Log.error("\(DevTools.Strings.not_iOS13) : Cant set tabBarItem")
            }
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
