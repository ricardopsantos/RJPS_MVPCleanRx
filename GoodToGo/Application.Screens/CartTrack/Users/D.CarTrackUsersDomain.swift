//
//  D.CarTrackUsersDomain.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/05/2020.
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
    struct CarTrackUsersView {
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

protocol CarTrackUsersBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.CarTrackUsers.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomeStuff(request: VM.CarTrackUsers.SomeStuff.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol CarTrackUsersPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.CarTrackUsers.__XXX__.Response)
    func presentScreenInitialState(response: VM.CarTrackUsers.ScreenInitialState.Response)
    func presentSomeStuff(response: VM.CarTrackUsers.SomeStuff.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol CarTrackUsersDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.CarTrackUsers.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.CarTrackUsers.ScreenInitialState.ViewModel)
    func displaySomeStuff(viewModel: VM.CarTrackUsers.SomeStuff.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol CarTrackUsersRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol CarTrackUsersDataPassingProtocol {

    // DataStore
    var dsCarTrackUsers: CarTrackUsersDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol CarTrackUsersDataStoreProtocol {
    // must have a reference like [var dataStore: CarTrackUsersDataStoreProtocol?]
    var dsSomeKindOfModelA: CarTrackUsersDataStoreModelA? { get set }
    var dsSomeKindOfModelB: CarTrackUsersDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct CarTrackUsersDataStoreModelA {
    let aString: String
}

struct CarTrackUsersDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum CarTrackUsers {
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
                let someListSectionAElements: [VM.CarTrackUsers.TableItem]
                let someListSectionBElements: [VM.CarTrackUsers.TableItem]
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
                let screenLayout: E.CarTrackUsersView.ScreenLayout
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

extension VM.CarTrackUsers {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.CarTrackUsers.CellType
        public var identity: VM.CarTrackUsers.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.CarTrackUsers.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.CarTrackUsers.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
