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
//import Differentiator
import RxCocoa
import RxSwift
//import RxDataSources
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase

extension R {
    class ___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___DataPassingProtocol {
        weak var viewController: VC.___VARIABLE_sceneName___ViewController?

        // DataPassingProtocol Protocol vars...
        var dataStore___VARIABLE_sceneName___: ___VARIABLE_sceneName___DataStoreProtocol? { didSet { AppLogger.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RoutingLogicProtocol {
    func dismissMe() {

    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: ___VARIABLE_sceneName___DataStoreProtocol, destination: inout ___VARIABLE_sceneName___DataStoreProtocol) {
            destination.dsSomeEntityModel = source.dsSomeEntityModel
        }
        let destinationVC = VC.___VARIABLE_sceneName___ViewController()
        if var destinationDS = destinationVC.router?.dataStore___VARIABLE_sceneName___ {
            passDataToSomewhere(source: dataStore___VARIABLE_sceneName___!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }

}
