//
//  R.DataStoreReceiverRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 20/05/2020.
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
    class DataStoreReceiverRouter: DataStoreReceiverDataPassingProtocol { // <<-- DS Sample : Take notice
        weak var viewController: VC.DataStoreReceiverViewController?

        // DataPassingProtocol Protocol vars... // <<-- DS Sample : Take notice
        var dsToBeSetted: DataStoreReceiverDataStoreProtocol? {
            didSet {
                DevTools.Log.message("\(DataStoreReceiverRouter.self) Datastore was setted!")
            }
        }
     }
}

// MARK: RoutingLogicProtocol

extension R.DataStoreReceiverRouter: DataStoreReceiverRoutingLogicProtocol { }
