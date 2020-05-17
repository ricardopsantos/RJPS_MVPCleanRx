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
        deinit {
            if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self) was killed") }
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.___VARIABLE_sceneName___ViewController?

        // DataPassingProtocol Protocol vars...
        var ds___VARIABLE_sceneName___: ___VARIABLE_sceneName___DataStoreProtocol? { didSet { AppLogger.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: ___VARIABLE_sceneName___DataStoreProtocol, destination: inout ___VARIABLE_sceneName___DataStoreProtocol) {
            destination.dsSomeKindOfModelA = source.dsSomeKindOfModelA
            destination.dsSomeKindOfModelB = source.dsSomeKindOfModelB
        }
        let destinationVC = VC.___VARIABLE_sceneName___ViewController()
        if var destinationDS = destinationVC.router?.ds___VARIABLE_sceneName___ {
            passDataToSomewhere(source: ds___VARIABLE_sceneName___!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }

}
