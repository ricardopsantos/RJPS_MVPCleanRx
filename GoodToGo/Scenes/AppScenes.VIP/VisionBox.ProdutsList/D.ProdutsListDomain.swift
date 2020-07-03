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

//
// MARK: - Enums & Other Models
//

extension E {
    struct ProdutsListView {
        enum ScreenLayout {
            case layoutA
            case layoutB
        }
    }
}

// DataStore shared model
/*
struct ProdutsListDataStoreModelA {
    let aString: String
}

struct ProdutsListDataStoreModelB {
    let aString: String
}
*/
//
// MARK: - Interactor (Business Logic)
//

protocol ProdutsListBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.ProdutsList.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomething(request: VM.ProdutsList.Something.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol ProdutsListPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.ProdutsList.__XXX__.Response)
    func presentScreenInitialState(response: VM.ProdutsList.ScreenInitialState.Response)
    func presentSomething(response: VM.ProdutsList.Something.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol ProdutsListDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.ProdutsList.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.ProdutsList.ScreenInitialState.ViewModel)
    func displaySomething(viewModel: VM.ProdutsList.Something.ViewModel)
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
protocol ProdutsListDataPassingProtocol {

    // DataStore
    var dsSource: ProdutsListDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol ProdutsListDataStoreProtocol {
    // must have a reference like [var dataStore: ProdutsListDataStoreProtocol?]
    var dsSomeKindOfModelAThatWillBePassedToOtherRouter: SomeRandomModelA? { get set }
    var dsSomeKindOfModelBThatWillBePassedToOtherRouter: SomeRandomModelB? { get set }

}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum ProdutsList {
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
                let someListSectionAElements: [VM.ProdutsList.TableItem]
                let someListSectionBElements: [VM.ProdutsList.TableItem]
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
                let screenLayout: E.ProdutsListView.ScreenLayout
            }
        }
    }
}

extension VM.ProdutsList {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.ProdutsList.CellType
        public var identity: VM.ProdutsList.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.ProdutsList.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.ProdutsList.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
