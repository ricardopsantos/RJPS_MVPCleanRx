//
//  R.CarTrackLoginRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
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
    class CarTrackLoginRouter: CarTrackLoginDataPassingProtocol {
        weak var viewController: VC.CarTrackLoginViewController?

        // DataPassingProtocol Protocol vars...
        var dsCarTrackLogin: CarTrackLoginDataStoreProtocol? { didSet { AppLogger.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.CarTrackLoginRouter: CarTrackLoginRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: CarTrackLoginDataStoreProtocol, destination: inout CarTrackLoginDataStoreProtocol) {
            destination.dsSomeKindOfModelA = source.dsSomeKindOfModelA
            destination.dsSomeKindOfModelB = source.dsSomeKindOfModelB
        }
        let destinationVC = VC.CarTrackLoginViewController()
        if var destinationDS = destinationVC.router?.dsCarTrackLogin {
            passDataToSomewhere(source: dsCarTrackLogin!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }

}
