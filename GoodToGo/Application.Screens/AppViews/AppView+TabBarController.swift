//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Swinject

extension AppView {

    class TabBarController: UITabBarController {
        
        let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()
        override func loadView() {
            super.loadView()
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            let c1 = createControllers(tabName: "RxTesting", vc: RxTesting())
            let c2 = createControllers(tabName: "GitUser", vc: container.resolve(V.SearchUser_View.self)!)
            let c3 = createControllers(tabName: "Sample", vc: container.resolve(V.SampleView_View.self)!)
            let c4 = createControllers(tabName: "SampleRx", vc: container.resolve(V.SampleRxView_View.self)!)
            let c5 = createControllers(tabName: "Bliss", vc: container.resolve(V.BlissRoot_View.self)!)
            let c6 = createControllers(tabName: "Table", vc: container.resolve(V.SampleTableView_View.self)!)
            viewControllers = [c1, c2, c3, c4, c6]
        }
        
        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController{
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
