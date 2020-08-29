//
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
    struct DebugView {
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

protocol DebugBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.Styles.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.Debug.SomeStuff.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol DebugPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.Styles.__XXX__.Response)
    func presentScreenInitialState(response: VM.Debug.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.Debug.SomeStuff.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol DebugDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.Styles.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.Debug.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.Debug.SomeStuff.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol DebugRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol DebugDataPassingProtocol {

    // DataStore
    var dsStyles: DebugDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol DebugDataStoreProtocol {
    // must have a reference like [var dataStore: StylesDataStoreProtocol?]
    var dsSomeKindOfModelA: DebugDataStoreModelA? { get set }
    var dsSomeKindOfModelB: DebugDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct DebugDataStoreModelA {
    let aString: String
}

struct DebugDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum Debug {
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
                let someListSectionAElements: [VM.Debug.TableItem]
                let someListSectionBElements: [VM.Debug.TableItem]
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
                let screenLayout: E.DebugView.ScreenLayout
            }
        }
    }
}

extension VM.Debug {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.Debug.CellType
        public var identity: VM.Debug.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.Debug.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.Debug.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
