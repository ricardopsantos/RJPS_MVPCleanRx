//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
//
import BaseConstants
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import BaseUI

extension R {
    class ___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___DataPassingProtocol {
        deinit {
            DevTools.Log.logDeInit("\(___VARIABLE_sceneName___Router.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.___VARIABLE_sceneName___ViewController?

        // DataPassingProtocol Protocol vars...
        var dataStore: ___VARIABLE_sceneName___DataStoreProtocol?
     }
}

// MARK: RoutingLogicProtocol

extension R.___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeSomewhereWithDataStore() {
        func passData(source: ___VARIABLE_sceneName___DataStoreProtocol,
                      destination: inout ___VARIABLE_sceneName___DataStoreProtocol) {
            destination.dsSomeRandomModelA = source.dsSomeRandomModelA
            destination.dsSomeRandomModelB = source.dsSomeRandomModelB
        }
        let destinationVC = VC.___VARIABLE_sceneName___ViewController()
        if var destinationDS = destinationVC.router?.dataStore { 
            passData(source: dataStore!, destination: &destinationDS)
        }
        viewController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeSomewhereWithDataStore()
    }

}

// MARK: BaseRouterProtocol

extension R.___VARIABLE_sceneName___Router: BaseRouterProtocol {

}
