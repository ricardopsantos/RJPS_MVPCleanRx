//
//  D.CategoriesPickerDomain.swift
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

//
// MARK: - Interactor (Business Logic)
//

protocol CategoriesPickerBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.CategoriesPicker.__XXX__.Request)
    func requestScreenInitialState()
    func requestCategoryChange(request: VM.CategoriesPicker.CategoryChange.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol CategoriesPickerPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.CategoriesPicker.__XXX__.Response)
    func presentScreenInitialState(response: VM.CategoriesPicker.ScreenInitialState.Response)
    func presentCategoryChange(response: VM.CategoriesPicker.CategoryChange.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol CategoriesPickerDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.CategoriesPicker.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.CategoriesPicker.ScreenInitialState.ViewModel)
    func displayCategoryChange(viewModel: VM.CategoriesPicker.CategoryChange.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol CategoriesPickerRoutingLogicProtocol {
    func routeToCategoriesList()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol CategoriesPickerDataPassingProtocol {

    // DataStore
    var dsSource: CategoriesPickerDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol CategoriesPickerDataStoreProtocol {
    // must have a reference like [var dataStore: CategoriesPickerDataStoreProtocol?]
    var dsSelectedCategory: VisionBox.Category? { get set }
}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum CategoriesPicker {
        struct CategoryChange {
            private init() {}
            struct Request { /* ViewController -> Interactor */
                let category: VisionBox.Category
            }
            struct Response { /* Interactor -> Presenter */
            }
            struct ViewModel { /* Presenter -> ViewController */
            }
        }

        struct ScreenInitialState {
            private init() {}
            struct Request {}
            struct Response {}
            struct ViewModel {}
        }
    }
}
