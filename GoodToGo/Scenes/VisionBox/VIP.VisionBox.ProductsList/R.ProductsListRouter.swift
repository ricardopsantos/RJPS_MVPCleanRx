//
//  R.ProductsListRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
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
    class ProductsListRouter: ProductsListDataPassingProtocol {
        deinit {
            DevTools.Log.logDeInit("\(ProductsListRouter.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.ProductsListViewController?

        var dsSource: ProductsListDataStoreProtocol? { didSet { DevTools.Log.message("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.ProductsListRouter: ProductsListRoutingLogicProtocol {

    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToProductDetails() {
        func passDataToSomewhere(source: ProductsListDataStoreProtocol,
                                 destination: inout ProductDetailsDataStoreProtocol) {
            destination.dsProduct  = source.dsSelectedProduct
        }
        let destinationVC = VC.ProductDetailsViewController(presentationStyle: .modal)
        if var destinationDS = destinationVC.router?.dsSource {
            passDataToSomewhere(source: dsSource!, destination: &destinationDS)
        }
        viewController?.present(destinationVC, animated: true, completion: nil)
    }
}
