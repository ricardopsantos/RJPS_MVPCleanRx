//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
import RxDataSources
//
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import BaseUI

//
// MARK: - Enums & Other Models
//

struct DebugScreen {
    enum ScreenLayout {
        case unknown
        case layoutA
        case layoutB
    }
}

//
// MARK: - Interactor (Business Logic)
//

protocol DevScreenBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.Styles.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.DevScreen.SomeStuff.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol DevScreenPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.Styles.__XXX__.Response)
    func presentScreenInitialState(response: VM.DevScreen.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.DevScreen.SomeStuff.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol DevScreenDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.Styles.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.DevScreen.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.DevScreen.SomeStuff.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol DevScreenRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol DevScreenDataPassingProtocol {

    // DataStore
    var dataStore: DevScreenDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol DevScreenDataStoreProtocol {
    // must have a reference like [var dataStore: StylesDataStoreProtocol?]
    var dsSomeKindOfModelA: DevScreenDataStoreModelA? { get set }
    var dsSomeKindOfModelB: DevScreenDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct DevScreenDataStoreModelA {
    let aString: String
}

struct DevScreenDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum DevScreen {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct SomeStuff {
            struct Request { /* ViewController -> Interactor */
                let userId: String
            }
            struct Response { /* Interactor -> Presenter */
                //let listA: [TemplateModel]
                //let listB: [TemplateModel]
                let subTitle: String
            }
            struct ViewModel { /* Presenter -> ViewController */
                let subTitle: String
                let someValue: String
                let someListSectionATitle: String
                let someListSectionBTitle: String
                let someListSectionAElements: [VM.DevScreen.TableItem]
                let someListSectionBElements: [VM.DevScreen.TableItem]
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
                let screenLayout: DebugScreen.ScreenLayout
            }
        }
    }
}

extension VM.DevScreen {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.DevScreen.CellType
        public var identity: VM.DevScreen.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.DevScreen.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.DevScreen.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
