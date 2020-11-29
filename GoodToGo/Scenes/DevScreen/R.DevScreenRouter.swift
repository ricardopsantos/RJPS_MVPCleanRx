//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
//
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import BaseUI

extension R {
    class DevScreenRouter: DevScreenDataPassingProtocol {
        weak var viewController: VC.DevScreenViewController?

        // DataPassingProtocol Protocol vars...
        var dataStore: DevScreenDataStoreProtocol? { didSet { DevTools.Log.message("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.DevScreenRouter: DevScreenRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: DevScreenDataStoreProtocol, destination: inout DevScreenDataStoreProtocol) {
            destination.dsSomeKindOfModelA = source.dsSomeKindOfModelA
            destination.dsSomeKindOfModelB = source.dsSomeKindOfModelB
        }
        let destinationVC = VC.DevScreenViewController()
        if var destinationDS = destinationVC.router?.dataStore {
            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }
}

// MARK: BaseRouterProtocol

extension R.DevScreenRouter: BaseRouterProtocol {

}
