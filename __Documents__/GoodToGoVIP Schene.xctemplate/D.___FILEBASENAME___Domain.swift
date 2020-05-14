//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
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
    struct ___VARIABLE_sceneName___View {
        enum ScreenLayout {
            case layoutA
            case layoutB
        }
    }
}

//
// MARK: - Interactor (Business Logic)
//

protocol ___VARIABLE_sceneName___BusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.___VARIABLE_sceneName___.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomething(request: VM.___VARIABLE_sceneName___.Something.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol ___VARIABLE_sceneName___PresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.___VARIABLE_sceneName___.__XXX__.Response)
    func presentScreenInitialState(response: VM.___VARIABLE_sceneName___.ScreenInitialState.Response)
    func presentSomething(response: VM.___VARIABLE_sceneName___.Something.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol ___VARIABLE_sceneName___DisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.___VARIABLE_sceneName___.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.___VARIABLE_sceneName___.ScreenInitialState.ViewModel)
    func displaySomething(viewModel: VM.___VARIABLE_sceneName___.Something.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol ___VARIABLE_sceneName___RoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol ___VARIABLE_sceneName___DataPassingProtocol {

    // DataStore
    var ds___VARIABLE_sceneName___: ___VARIABLE_sceneName___DataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol ___VARIABLE_sceneName___DataStoreProtocol {
    // must have a reference like [var dataStore: ___VARIABLE_sceneName___DataStoreProtocol?]
    var dsSomeKindOfModelA: ___VARIABLE_sceneName___DataStoreModelA? { get set }
    var dsSomeKindOfModelB: ___VARIABLE_sceneName___DataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct ___VARIABLE_sceneName___DataStoreModelA {
    let aString: String
}

struct ___VARIABLE_sceneName___DataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum ___VARIABLE_sceneName___ {
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
                let someListSectionAElements: [VM.___VARIABLE_sceneName___.TableItem]
                let someListSectionBElements: [VM.___VARIABLE_sceneName___.TableItem]
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
                let screenLayout: E.___VARIABLE_sceneName___View.ScreenLayout
            }
        }
    }
}

extension VM.___VARIABLE_sceneName___ {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.___VARIABLE_sceneName___.CellType
        public var identity: VM.___VARIABLE_sceneName___.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.___VARIABLE_sceneName___.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.___VARIABLE_sceneName___.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
