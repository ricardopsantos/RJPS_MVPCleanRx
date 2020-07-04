//
//  R.CategoriesPickerRouter.swift
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
    class CategoriesPickerRouter: CategoriesPickerDataPassingProtocol {
        deinit {
            DevTools.Log.logDeInit("\(CategoriesPickerRouter.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.CategoriesPickerViewController?

        // DataPassingProtocol Protocol vars...
        var dsSource: CategoriesPickerDataStoreProtocol? { didSet { DevTools.Log.message("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.CategoriesPickerRouter: CategoriesPickerRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToCategoriesList() {
        func passDataToSomewhere(source: CategoriesPickerDataStoreProtocol,
                                 destination: inout ProductsListDataStoreProtocol) {
            destination.dsSelectedCategory = source.dsSelectedCategory
        }
        let destinationVC = VC.ProductsListViewController(presentationStyle: .modal)
        if var destinationDS = destinationVC.router?.dsSource {
            passDataToSomewhere(source: dsSource!, destination: &destinationDS)
        }
        viewController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToCategoriesList()
    }

}
