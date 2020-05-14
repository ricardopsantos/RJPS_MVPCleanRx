//
//  D.CartTrackMapDomain.swift
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
    struct CartTrackMapView {
        enum ScreenLayout {
            case unknown
            case layoutB
        }
    }
}

//
// MARK: - Interactor (Business Logic)
//

protocol CartTrackMapBusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.CartTrackMap.__XXX__.Request)
    func requestScreenInitialState()
    func requestUserInfo(request: VM.CartTrackMap.UserInfo.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol CartTrackMapPresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.CartTrackMap.__XXX__.Response)
    func presentScreenInitialState(response: VM.CartTrackMap.ScreenInitialState.Response)
    func presentUserInfo(response: VM.CartTrackMap.UserInfo.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol CartTrackMapDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.CartTrackMap.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel)
    func displayUserInfo(viewModel: VM.CartTrackMap.UserInfo.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol CartTrackMapRoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeToTemplateWithParentDataStore()
    func routeToTemplateWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol CartTrackMapDataPassingProtocol {

    // DataStore
    var dsCartTrackMap: CartTrackMapDataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol CartTrackMapDataStoreProtocol {
    // must have a reference like [var dataStore: CartTrackMapDataStoreProtocol?]
    var dsSomeKindOfModelA: CartTrackMapDataStoreModelA? { get set }
    var dsSomeKindOfModelB: CartTrackMapDataStoreModelB? { get set }

}

//
// MARK: - Models
//

// DataStore

struct CartTrackMapDataStoreModelA {
    let aString: String
}

struct CartTrackMapDataStoreModelB {
    let aString: String
}

// Other Models

extension VM {
    enum CartTrackMap {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct UserInfo {
            struct Request { /* ViewController -> Interactor */
                let userId: String
            }
            struct Response { /* Interactor -> Presenter */
                let list: [CarTrack.UserModel]
            }
            struct ViewModel { /* Presenter -> ViewController */
                let subTitle: String
                let list: [CarTrack.UserModel]
            }
        }

        struct ScreenInitialState {
            struct Request { }
            struct Response { }
            struct ViewModel { }
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

extension VM.CartTrackMap {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.CartTrackMap.CellType
        public var identity: VM.CartTrackMap.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.CartTrackMap.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.CartTrackMap.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
