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

            // EXAMS
            let vipCarTrack   = createControllers(tabName: "VIP.CarTrack", vc: VC.CarTrackLoginViewController(presentationStyle: .modal))
            let vipGalleryApp = createControllers(tabName: "VIP.Gallery", vc: VC.GalleryAppS1ViewController(presentationStyle: .modal))

            // TESTING / DEBUG/ TEMPLATES
            let vipTemplate = createControllers(tabName: "VIP.Template", vc: VC.___VARIABLE_sceneName___ViewController(presentationStyle: .modal))
            let vipDebug    = createControllers(tabName: "DevScreen", vc: VC.DebugViewController(presentationStyle: .modal))

            var viewControllersList: [UIViewController] = []
            if DevTools.FeatureFlag.showScene_gallery.isTrue { viewControllersList.append(vipGalleryApp) }
            if DevTools.FeatureFlag.showScene_carTrack.isTrue { viewControllersList.append(vipCarTrack) }
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
