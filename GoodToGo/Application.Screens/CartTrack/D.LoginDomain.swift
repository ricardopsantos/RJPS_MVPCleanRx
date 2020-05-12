//
//  D.LoginDomain.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
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

extension E {
    struct LoginView {
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

protocol LoginBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.Login.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.Login.SomeStuff.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol LoginPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.Login.__XXX__.Response)
    func presentScreenInitialState(response: VM.Login.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.Login.SomeStuff.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol LoginDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.Login.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.Login.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.Login.SomeStuff.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol LoginRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol LoginDataPassingProtocol {

    // DataStore
    var dsLogin: LoginDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol LoginDataStoreProtocol {
    // must have a reference like [var dataStore: LoginDataStoreProtocol?]
    var dsSomeKindOfModelA: LoginDataStoreModelA? { get set }
    var dsSomeKindOfModelB: LoginDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct LoginDataStoreModelA {
    let aString: String
}

struct LoginDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum Login {
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
                let someListSectionAElements: [VM.Login.TableItem]
                let someListSectionBElements: [VM.Login.TableItem]
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
                let screenLayout: E.LoginView.ScreenLayout
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

extension VM.Login {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.Login.CellType
        public var identity: VM.Login.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.Login.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.Login.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
