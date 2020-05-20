//
//  D.DataStoreReceiverDomain.swift
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
    // Naming convention : func request__XXX__(viewModel: VM.DataStoreReceiver.__XXX__.Request)
    func requestScreenInitialState()
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol DataStoreReceiverPresentationLogicProtocol: BasePresenterVIPProtocol {

}

//
// MARK: - ViewController (Display Logic)
//

protocol DataStoreReceiverDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.DataStoreReceiver.__XXX__.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol DataStoreReceiverRoutingLogicProtocol {

}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol DataStoreReceiverDataPassingProtocol {

    // DataStore
    var dsDataStoreReceiver: DataStoreReceiverDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol DataStoreReceiverDataStoreProtocol {
    // must have a reference like [var dataStore: DataStoreReceiverDataStoreProtocol?]
    var dsSomeKindOfModelA: DataStoreReceiverDataStoreModelA? { get set }
    var dsSomeKindOfModelB: DataStoreReceiverDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct DataStoreReceiverDataStoreModelA {
    let aString: String
}

struct DataStoreReceiverDataStoreModelB {
    let aString: String
}
