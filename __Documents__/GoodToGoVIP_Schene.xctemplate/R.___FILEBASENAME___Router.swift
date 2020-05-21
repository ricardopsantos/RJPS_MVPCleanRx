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
            DevTools.Log.logDeInit("\(___VARIABLE_sceneName___Router.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.___VARIABLE_sceneName___ViewController?

        // DataPassingProtocol Protocol vars...
        var dsSource: ___VARIABLE_sceneName___DataStoreProtocol? { didSet { DevTools.Log.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeSomewhereWithDataStore() {
        func passDataToSomewhere(source: ___VARIABLE_sceneName___DataStoreProtocol,
                                 destination: inout DataStoreReceiverDataStoreProtocol) { // <<-- DS Sample : Take notice
            destination.dsSomeKindOfModelAToBeSettedByOtherRouter = source.dsSomeKindOfModelAThatWillBePassedToOtherRouter
            //destination.dsSomeKindOfModelBToBeSettedByOtherRouter = source.dsSomeKindOfModelBThatWillBePassedToOtherRouter
        }
        let destinationVC = VC.DataStoreReceiverViewController(presentationStyle: .regularVC)    // <<-- DS Sample : Take notice
        if var destinationDS = destinationVC.router?.dsToBeSetted { // <<-- DS Sample : Take notice
            passDataToSomewhere(source: dsSource!, destination: &destinationDS)
        }
        viewController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeSomewhereWithDataStore()
    }

}
