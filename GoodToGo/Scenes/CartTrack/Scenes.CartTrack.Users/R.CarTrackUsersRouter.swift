//
//  R.CarTrackUsersRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
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
    class CarTrackUsersRouter: CarTrackUsersDataPassingProtocol {
        weak var viewController: VC.CarTrackUsersViewController?

        // DataPassingProtocol Protocol vars...
        var dsCarTrackUsers: CarTrackUsersDataStoreProtocol? { didSet { AppLogger.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.CarTrackUsersRouter: CarTrackUsersRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: CarTrackUsersDataStoreProtocol, destination: inout CarTrackUsersDataStoreProtocol) {
            destination.dsSomeKindOfModelA = source.dsSomeKindOfModelA
            destination.dsSomeKindOfModelB = source.dsSomeKindOfModelB
        }
        let destinationVC = VC.CarTrackUsersViewController()
        if var destinationDS = destinationVC.router?.dsCarTrackUsers {
            passDataToSomewhere(source: dsCarTrackUsers!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }

}
