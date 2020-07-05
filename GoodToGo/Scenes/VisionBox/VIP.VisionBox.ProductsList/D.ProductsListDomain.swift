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

protocol ProductsListBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.ProductsList.__XXX__.Request)
    func requestScreenInitialState()
    func requestFilterProducts(viewModel: VM.ProductsList.FilterProducts.Request)
    func requestShowProductDetails(viewModel: VM.ProductsList.ShowProductDetails.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol ProductsListPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.ProductsList.__XXX__.Response)
    func presentScreenInitialState(response: VM.ProductsList.ScreenInitialState.Response)
    func presentSomething(response: VM.ProductsList.FilterProducts.Response)
    func presentShowProductDetails(response: VM.ProductsList.ShowProductDetails.Response)

}

//
// MARK: - ViewController (Display Logic)
//

protocol ProductsListDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.ProductsList.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.ProductsList.ScreenInitialState.ViewModel)
    func displayFilterProducts(viewModel: VM.ProductsList.FilterProducts.ViewModel)
    func displayShowProductDetails(viewModel: VM.ProductsList.ShowProductDetails.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol ProductsListRoutingLogicProtocol {
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
    var dsSelectedProduct: VisionBox.ProductModel? { get set }
}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum ProductsList {

        struct ShowProductDetails {
            private init() { }
            struct Request {
                let product: VisionBox.ProductModel
            }
            struct Response {
            }
            struct ViewModel {
            }
        }

        struct FilterProducts {
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
