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
//import Differentiator
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

struct ___VARIABLE_sceneName___Auxiliary__SomeEntityModel {
    let value: String
}

extension E {
    struct ___VARIABLE_sceneName___View {
        enum ScreenLayout {
            case unknown
            case layoutA
            case layoutB
        }
    }
}

//
// MARK: - ViewController
//

protocol ___VARIABLE_sceneName___DisplayLogicProtocol: BaseDisplayLogicProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.___VARIABLE_sceneName___.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.___VARIABLE_sceneName___.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.___VARIABLE_sceneName___.SomeStuff.ViewModel)
}

//
// MARK: - Interactor
//

protocol ___VARIABLE_sceneName___BusinessLogicProtocol: InteratorMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.___VARIABLE_sceneName___.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.___VARIABLE_sceneName___.SomeStuff.Request)
}

protocol ___VARIABLE_sceneName___DataStoreProtocol {
    // Implemented by the Interactor, and the Router must have a reference like [var dataStore: ___VARIABLE_sceneName___DataStoreProtocol?]
    var dsSomeEntityModel: ___VARIABLE_sceneName___Auxiliary__SomeEntityModel? { get set }
}

//
// MARK: - Router
//

// Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol ___VARIABLE_sceneName___DataPassingProtocol {

    #warning("DEV - After using template, change [dataStore___VARIABLE_sceneName___] to [dataStore]")
    var dataStore___VARIABLE_sceneName___: ___VARIABLE_sceneName___DataStoreProtocol? { get }
}

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol ___VARIABLE_sceneName___RoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - Presenter
//

protocol ___VARIABLE_sceneName___PresentationLogicProtocol: BasePresentationLogicProtocol {
    // Naming convention : func present__XXX__(response: VM.___VARIABLE_sceneName___.__XXX__.Response)
    func presentScreenInitialState(response: VM.___VARIABLE_sceneName___.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.___VARIABLE_sceneName___.SomeStuff.Response)
}

//
// MARK: - Model
//

extension VM {
    enum ___VARIABLE_sceneName___ {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct SomeStuff {
            struct Request {
                let userId: String
            }
            struct Response {
                let listA: [TemplateModel]
                let listB: [TemplateModel]
                let subTitle: String
            }
            struct ViewModel {
                let subTitle: String
                let someValue: String
                let someListSectionATitle: String
                let someListSectionBTitle: String
                let someListSectionAElements: [VM.___VARIABLE_sceneName___.TableItem]
                let someListSectionBElements: [VM.___VARIABLE_sceneName___.TableItem]
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
                let screenLayout: E.___VARIABLE_sceneName___View.ScreenLayout
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
