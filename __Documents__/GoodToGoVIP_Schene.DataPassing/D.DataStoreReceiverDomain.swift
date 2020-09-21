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
import RxDataSources
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase

//
// MARK: - Interactor (Business Logic)
//

protocol DataStoreReceiverBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    func requestScreenInitialState()
}

// MARK: - Presenter (Presentation Logic)
protocol DataStoreReceiverPresentationLogicProtocol: BasePresenterVIPProtocol { }

// MARK: - ViewController (Display Logic)
protocol DataStoreReceiverDisplayLogicProtocol: BaseViewControllerVIPProtocol { }

// MARK: - Router (Routing Logic)
protocol DataStoreReceiverRoutingLogicProtocol { }

// ###############################################
// # MARK: - DataStore
// ###############################################

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol DataStoreReceiverDataPassingProtocol {
    var dsToBeSetted: DataStoreReceiverDataStoreProtocol? { get set } // <<-- DS Sample : Take notice
}

// DataStore : Implemented by the Interactor, and the Router // <<-- DS Sample : Take notice
protocol DataStoreReceiverDataStoreProtocol {
    var dsSomeKindOfModelAToBeSettedByOtherRouter: SomeRandomModelA? { get set }
    var dsSomeKindOfModelBToBeSettedByOtherRouter: SomeRandomModelB? { get set }
}

// DataStore Model (shared between source and target) // <<-- DS Sample : Take notice

struct SomeRandomModelA { let s1: String }
struct SomeRandomModelB { let s2: String }
