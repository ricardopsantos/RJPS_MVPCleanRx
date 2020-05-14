//
//  D.StylesDomain.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
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
    struct StylesView {
        enum ScreenLayout {
            case unknown
            case layoutA
            case layoutB
        }
    }
}

//
// MARK: - Interactor (Business Logic)
//

protocol StylesBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.Styles.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.Styles.SomeStuff.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol StylesPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.Styles.__XXX__.Response)
    func presentScreenInitialState(response: VM.Styles.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.Styles.SomeStuff.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol StylesDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.Styles.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.Styles.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.Styles.SomeStuff.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol StylesRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol StylesDataPassingProtocol {

    // DataStore
    var dsStyles: StylesDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol StylesDataStoreProtocol {
    // must have a reference like [var dataStore: StylesDataStoreProtocol?]
    var dsSomeKindOfModelA: StylesDataStoreModelA? { get set }
    var dsSomeKindOfModelB: StylesDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct StylesDataStoreModelA {
    let aString: String
}

struct StylesDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum Styles {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct SomeStuff {
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
                let someListSectionAElements: [VM.Styles.TableItem]
                let someListSectionBElements: [VM.Styles.TableItem]
            }
        }

        struct ScreenInitialState {
            struct Request {}
            struct Response {
                let title: String
                let subTitle: String
            }
            struct ViewModel {
                let title: String
                let subTitle: String
                let screenLayout: E.StylesView.ScreenLayout
            }
        }

        enum Error {
            struct Response {
                let title: String
                let message: String
                let shouldRouteBack: Bool
            }
        }
    }
}

extension VM.Styles {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.Styles.CellType
        public var identity: VM.Styles.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.Styles.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.Styles.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
