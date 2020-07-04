//
//  D.ProdutsListDomain.swift
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

protocol ProdutsListBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.ProdutsList.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomething(viewModel: VM.ProductsList.Something.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol ProdutsListPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.ProdutsList.__XXX__.Response)
    func presentScreenInitialState(response: VM.ProductsList.ScreenInitialState.Response)
    func presentSomething(response: VM.ProductsList.Something.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol ProdutsListDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.ProdutsList.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.ProductsList.ScreenInitialState.ViewModel)
    func displaySomething(viewModel: VM.ProductsList.Something.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol ProdutsListRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeSomewhereWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol ProductsListDataPassingProtocol {

    // DataStore
    var dsSource: ProductsListDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol ProductsListDataStoreProtocol {
    // must have a reference like [var dataStore: ProductsListDataStoreProtocol?]
    var dsSelectedCategory: VisionBox.Category? { get set }
}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum ProductsList {
        struct Something {
            private init() { }
            struct Request {
                let search: String
            }
            struct Response {
                let products: [VisionBox.ProductModel]
            }
            struct ViewModel {
                let products: [VisionBox.ProductModel]
            }
        }

        struct ScreenInitialState {
            private init() { }
            struct Request { }
            struct Response {
                let products: [VisionBox.ProductModel]
            }
            struct ViewModel {
                let products: [VisionBox.ProductModel]
            }
        }
    }
}
