//
//  R.CartTrackMapRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
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
    class CartTrackMapRouter: CartTrackMapDataPassingProtocol {
        weak var viewController: VC.CartTrackMapViewController?

     }
}

// MARK: RoutingLogicProtocol

extension R.CartTrackMapRouter: CartTrackMapRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

}
