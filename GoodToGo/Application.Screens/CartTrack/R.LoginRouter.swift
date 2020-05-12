//
//  R.LoginRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
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
    class LoginRouter: LoginDataPassingProtocol {
        weak var viewController: VC.LoginViewController?

        // DataPassingProtocol Protocol vars...
        var dsLogin: LoginDataStoreProtocol? { didSet { AppLogger.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.LoginRouter: LoginRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: LoginDataStoreProtocol, destination: inout LoginDataStoreProtocol) {
            destination.dsSomeKindOfModelA = source.dsSomeKindOfModelA
            destination.dsSomeKindOfModelB = source.dsSomeKindOfModelB
        }
        let destinationVC = VC.LoginViewController()
        if var destinationDS = destinationVC.router?.dsLogin {
            passDataToSomewhere(source: dsLogin!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }

}
