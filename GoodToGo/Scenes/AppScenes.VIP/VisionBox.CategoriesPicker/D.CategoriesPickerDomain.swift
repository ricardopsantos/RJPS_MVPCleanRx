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
// MARK: - Enums & Other Models
//

extension E {
    struct CategoriesPickerView {
        enum ScreenLayout {
            case layoutA
            case layoutB
        }
    }
}

// DataStore shared model
/*
struct CategoriesPickerDataStoreModelA {
    let aString: String
}

struct CategoriesPickerDataStoreModelB {
    let aString: String
}
*/
//
// MARK: - Interactor (Business Logic)
//

protocol CategoriesPickerBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.CategoriesPicker.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomething(request: VM.CategoriesPicker.Something.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol CategoriesPickerPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.CategoriesPicker.__XXX__.Response)
    func presentScreenInitialState(response: VM.CategoriesPicker.ScreenInitialState.Response)
    func presentSomething(response: VM.CategoriesPicker.Something.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol CategoriesPickerDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.CategoriesPicker.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.CategoriesPicker.ScreenInitialState.ViewModel)
    func displaySomething(viewModel: VM.CategoriesPicker.Something.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol CategoriesPickerRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeSomewhereWithDataStore()
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
    var dsSomeKindOfModelAThatWillBePassedToOtherRouter: SomeRandomModelA? { get set }
    var dsSomeKindOfModelBThatWillBePassedToOtherRouter: SomeRandomModelB? { get set }

}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum CategoriesPicker {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct Something {
            private init() {}
            struct Request { /* ViewController -> Interactor */
                let userId: String
            }
            struct Response { /* Interactor -> Presenter */
                let listA: [TemplateModel]
                let listB: [TemplateModel]
                let subTitle: String
            }
            struct ViewModel { /* Presenter -> ViewController */
                let subTitle: String
                let someValue: String
                let someListSectionATitle: String
                let someListSectionBTitle: String
                let someListSectionAElements: [VM.CategoriesPicker.TableItem]
                let someListSectionBElements: [VM.CategoriesPicker.TableItem]
            }
        }

        struct ScreenInitialState {
            private init() {}
            struct Request {}
            struct Response {
                let title: String
                let subTitle: String
            }
            struct ViewModel {
                let title: String
                let subTitle: String
                let screenLayout: E.CategoriesPickerView.ScreenLayout
            }
        }
    }
}

extension VM.CategoriesPicker {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.CategoriesPicker.CellType
        public var identity: VM.CategoriesPicker.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.CategoriesPicker.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.CategoriesPicker.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
