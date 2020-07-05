//
//  R.ProductDetailsRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
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
    class ProductDetailsRouter: ProductDetailsDataPassingProtocol {
        deinit {
            DevTools.Log.logDeInit("\(ProductDetailsRouter.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.ProductDetailsViewController?

        // DataPassingProtocol Protocol vars...
        var dsSource: ProductDetailsDataStoreProtocol? { didSet { DevTools.Log.message("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.ProductDetailsRouter: ProductDetailsRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToSomeWhere() {

    }

    func routeToTemplateWithParentDataStore() {
        routeToSomeWhere()
    }

}
