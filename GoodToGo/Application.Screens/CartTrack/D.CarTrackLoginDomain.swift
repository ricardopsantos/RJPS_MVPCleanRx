//
//  D.CarTrackLoginDomain.swift
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
    struct CarTrackLoginView {
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

protocol CarTrackLoginBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.CarTrackLogin.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.CarTrackLogin.SomeStuff.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol CarTrackLoginPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.CarTrackLogin.__XXX__.Response)
    func presentScreenInitialState(response: VM.CarTrackLogin.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.CarTrackLogin.SomeStuff.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol CarTrackLoginDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.CarTrackLogin.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.CarTrackLogin.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.CarTrackLogin.SomeStuff.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol CarTrackLoginRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol CarTrackLoginDataPassingProtocol {

    // DataStore
    var dsCarTrackLogin: CarTrackLoginDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol CarTrackLoginDataStoreProtocol {
    // must have a reference like [var dataStore: CarTrackLoginDataStoreProtocol?]
    var dsSomeKindOfModelA: CarTrackLoginDataStoreModelA? { get set }
    var dsSomeKindOfModelB: CarTrackLoginDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct CarTrackLoginDataStoreModelA {
    let aString: String
}

struct CarTrackLoginDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum CarTrackLogin {
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
                let someListSectionAElements: [VM.CarTrackLogin.TableItem]
                let someListSectionBElements: [VM.CarTrackLogin.TableItem]
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
                let screenLayout: E.CarTrackLoginView.ScreenLayout
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

extension VM.CarTrackLogin {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.CarTrackLogin.CellType
        public var identity: VM.CarTrackLogin.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.CarTrackLogin.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.CarTrackLogin.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
