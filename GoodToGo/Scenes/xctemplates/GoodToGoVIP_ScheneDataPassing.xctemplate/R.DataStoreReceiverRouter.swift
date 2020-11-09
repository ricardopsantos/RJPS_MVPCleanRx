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
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import BaseUI

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

// MARK: BaseRouterProtocol

extension R.DataStoreReceiverRouter: BaseRouterProtocol {

}
