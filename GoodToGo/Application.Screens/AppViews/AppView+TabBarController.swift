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
            
            let c1 = createControllers(tabName: "GitUser", vc: container.resolve(V.SearchUser_View.self)!)
            let c2 = createControllers(tabName: "MVP", vc: container.resolve(V.MVPSampleView_View.self)!)
            let c3 = createControllers(tabName: "MVPRx", vc: container.resolve(V.MVPSampleRxView_View.self)!)
            let c5 = createControllers(tabName: "MVPRxTable", vc: container.resolve(V.MVPSampleTableView_View.self)!)
            let c6 = createControllers(tabName: "RxTesting", vc: RxTesting())
            let c4 = createControllers(tabName: "Bliss", vc: container.resolve(V.BlissRoot_View.self)!)
            
            let mvvmVC = container.resolve(VC.MVVMSampleView_ViewController.self)!
            mvvmVC.viewModel = VM.MVVMSampleView_ViewModel(viewModel: M.MVVMSampleView.makeOne(name: "Dog_A"))
            let mvvm = createControllers(tabName: "MVVM", vc: mvvmVC)
            
            if true {
                viewControllers = [c1, c2, c3, c4, c5, c6]
            } else {
                viewControllers = [mvvm]
            }
        }
        
        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController{
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
