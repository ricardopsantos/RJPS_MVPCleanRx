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

    func routeSomewhereWithDataStore() {
        func passDataToSomewhere(source: CategoriesPickerDataStoreProtocol,
                                 destination: inout DataStoreReceiverDataStoreProtocol) { // <<-- DS Sample : Take notice
            destination.dsSomeKindOfModelAToBeSettedByOtherRouter = source.dsSomeKindOfModelAThatWillBePassedToOtherRouter
            //destination.dsSomeKindOfModelBToBeSettedByOtherRouter = source.dsSomeKindOfModelBThatWillBePassedToOtherRouter
        }
        let destinationVC = VC.DataStoreReceiverViewController(presentationStyle: .modal)    // <<-- DS Sample : Take notice
        if var destinationDS = destinationVC.router?.dsToBeSetted { // <<-- DS Sample : Take notice
            passDataToSomewhere(source: dsSource!, destination: &destinationDS)
        }
        viewController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeSomewhereWithDataStore()
    }

}
