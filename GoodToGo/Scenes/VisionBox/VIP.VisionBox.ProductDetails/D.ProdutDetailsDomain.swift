//
//  D.ProductDetailsDomain.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
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
import Domain_VisionBox
import Extensions
import PointFreeFunctions
import UIBase

//
// MARK: - Interactor (Business Logic)
//

protocol ProductDetailsBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.ProductDetails.__XXX__.Request)
    func requestScreenInitialState()
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol ProductDetailsPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.ProductDetails.__XXX__.Response)
    func presentScreenInitialState(response: VM.ProductDetails.ScreenInitialState.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol ProductDetailsDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.ProductDetails.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.ProductDetails.ScreenInitialState.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol ProductDetailsRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToSomeWhere()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol ProductDetailsDataPassingProtocol {

    // DataStore
    var dsSource: ProductDetailsDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol ProductDetailsDataStoreProtocol {
    // must have a reference like [var dataStore: ProductDetailsDataStoreProtocol?]
    var dsProduct: VisionBox.ProductModel? { get set }
}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum ProductDetails {
        struct ScreenInitialState {
            private init() { }
            struct Request { }
            struct Response {
                let productDetails: VisionBox.ProductModel
                let userAvatarImage: String
                let userAvatarName: String
                let productsList: [VisionBox.ProductModel]
            }
            struct ViewModel {
                let productDetails: VisionBox.ProductModel
                let userAvatarImage: String
                let userAvatarName: String
                let productsList: [VisionBox.ProductModel]
            }
        }
    }
}
