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
        var dsCarTrackLogin: CarTrackLoginDataStoreProtocol? { didSet { DevTools.Log.message("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.CarTrackLoginRouter: CarTrackLoginRoutingLogicProtocol {

    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToNextScreen() {
        let target = VC.CartTrackMapViewController()
        target.modalPresentationStyle = .fullScreen 
        viewController?.present(target, animated: true) { }
    }
}

// MARK: BaseRouterProtocol

extension R.CarTrackLoginRouter: BaseRouterProtocol {

}
