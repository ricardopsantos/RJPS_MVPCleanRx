//
//  R.GalleryAppS1Router.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
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
    class GalleryAppS1Router {
        deinit {
            DevTools.Log.logDeInit("\(GalleryAppS1Router.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: VC.GalleryAppS1ViewController?
     }
}

// MARK: RoutingLogicProtocol

extension R.GalleryAppS1Router: GalleryAppS1RoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }
}
