//
//  D.ProdutDetailsDomain.swift
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
import Extensions
import PointFreeFunctions
import UIBase

//
// MARK: - Enums & Other Models
//

// DataStore shared model
/*
struct ProdutDetailsDataStoreModelA {
    let aString: String
}

struct ProdutDetailsDataStoreModelB {
    let aString: String
}
*/
//
// MARK: - Interactor (Business Logic)
//

protocol ProdutDetailsBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.ProdutDetails.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomething(request: VM.ProdutDetails.Something.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol ProdutDetailsPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.ProdutDetails.__XXX__.Response)
    func presentScreenInitialState(response: VM.ProdutDetails.ScreenInitialState.Response)
    func presentSomething(response: VM.ProdutDetails.Something.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol ProdutDetailsDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.ProdutDetails.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.ProdutDetails.ScreenInitialState.ViewModel)
    func displaySomething(viewModel: VM.ProdutDetails.Something.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol ProdutDetailsRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeSomewhereWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol ProdutDetailsDataPassingProtocol {

    // DataStore
    var dsSource: ProdutDetailsDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol ProdutDetailsDataStoreProtocol {
    // must have a reference like [var dataStore: ProdutDetailsDataStoreProtocol?]
    var dsSomeKindOfModelAThatWillBePassedToOtherRouter: SomeRandomModelA? { get set }
    var dsSomeKindOfModelBThatWillBePassedToOtherRouter: SomeRandomModelB? { get set }

}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum ProdutDetails {
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
                let someListSectionAElements: [VM.ProdutDetails.TableItem]
                let someListSectionBElements: [VM.ProdutDetails.TableItem]
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
                let productDetails: ProductModel
                let userAvatarImage: String
                let userAvatarName: String
                let productsList: [ProductModel]
            }
        }
    }
}

extension VM.ProdutDetails {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.ProdutDetails.CellType
        public var identity: VM.ProdutDetails.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.ProdutDetails.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.ProdutDetails.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
