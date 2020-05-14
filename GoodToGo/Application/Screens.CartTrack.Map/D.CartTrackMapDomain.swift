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
    func requestScreenInitialState()
    func requestMapData(request: VM.CartTrackMap.MapData.Request)
    func requestMapDataFilter(viewModel: VM.CartTrackMap.MapDataFilter.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol CartTrackMapPresentationLogicProtocol: BasePresenterVIPProtocol {
    func presentScreenInitialState(response: VM.CartTrackMap.ScreenInitialState.Response)
    func presentMapData(response: VM.CartTrackMap.MapData.Response)
    func presentMapDataFilter(response: VM.CartTrackMap.MapDataFilter.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol CartTrackMapDisplayLogicProtocol: BaseViewControllerVIPProtocol {
    func displayScreenInitialState(viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel)
    func displayMapData(viewModel: VM.CartTrackMap.MapData.ViewModel)
    func displayMapDataFilter(viewModel: VM.CartTrackMap.MapDataFilter.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol CartTrackMapRoutingLogicProtocol {

}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol CartTrackMapDataPassingProtocol {

}

// DataStore : Implemented by the Interactor, and the Router
protocol CartTrackMapDataStoreProtocol {

}

//
// MARK: - Models
//

extension VM {
    enum CartTrackMap {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct MapData {
            struct Request { } /* ViewController -> Interactor */
            struct Response { /* Interactor -> Presenter */
                let list: [CarTrack.UserModel]
            }
            struct ViewModel { /* Presenter -> ViewController */
                let subTitle: String
                let list: [CarTrack.UserModel]
            }
        }

        struct MapDataFilter { /* ViewController -> Interactor */
            struct Request {
                let filter: String
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
