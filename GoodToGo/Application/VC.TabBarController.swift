//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
            
            let c1 = createControllers(tabName: "GitUser", vc: AppDelegate.shared.container.resolve(V.SearchUser_View.self)!)
            let c2 = createControllers(tabName: "MVP", vc: AppDelegate.shared.container.resolve(V.MVPSampleView_View.self)!)
            let c3 = createControllers(tabName: "MVPRx", vc: AppDelegate.shared.container.resolve(V.MVPSampleRxView_View.self)!)
            let c4 = createControllers(tabName: "Bliss", vc: AppDelegate.shared.container.resolve(V.BlissRoot_View.self)!)
            let c5 = createControllers(tabName: "MVPRxTable", vc: AppDelegate.shared.container.resolve(V.MVPSampleTableView_View.self)!)
            let c6 = createControllers(tabName: "RxTesting", vc: RxTesting())

            //let mvvmVC = container.resolve(VC.MVVMSampleView_ViewController.self)!
            //mvvmVC.viewModel = VM.MVVMSampleView_ViewModel(viewModel: M.MVVMSampleView.makeOne(name: "Dog_A"))
            //let mvvm = createControllers(tabName: "MVVM", vc: mvvmVC)

            let vip1 = createControllers(tabName: "VIP", vc: SampleVIP_ViewController())
            let vip2 = VC.___VARIABLE_sceneName___ViewController()
            let carTrackLoginViewController = VC.CarTrackLoginViewController()
            let carTrackUsersViewController = VC.CarTrackUsersViewController()
            let cartTrackMapViewController = VC.CartTrackMapViewController()
            let stylesViewController = VC.StylesViewController()

            carTrackLoginViewController.tabBarItem.title = "Login"
            cartTrackMapViewController.tabBarItem.title = "Map"
            stylesViewController.tabBarItem.title = "Styles"

            if false {
                viewControllers = [vip2, c1, c2, c3, c4, c5, c6]
            } else {
                viewControllers = [cartTrackMapViewController, carTrackLoginViewController, stylesViewController]
            }
        }
        
        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController {
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
