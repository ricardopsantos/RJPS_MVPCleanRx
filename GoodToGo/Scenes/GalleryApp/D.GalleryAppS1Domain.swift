//
//  D.GalleryAppS1Domain.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
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
    struct GalleryAppS1View {
        enum ScreenLayout {
            case layoutA
            case layoutB
        }
    }
}

// DataStore shared model
/*
struct GalleryAppS1DataStoreModelA {
    let aString: String
}

struct GalleryAppS1DataStoreModelB {
    let aString: String
}
*/
//
// MARK: - Interactor (Business Logic)
//

protocol GalleryAppS1BusinessLogicProtocol: BaseInteractorVIPMandatoryBusinessLogicProtocol {
    // Naming convention : func request__XXX__(viewModel: VM.GalleryAppS1.__XXX__.Request)
    func requestScreenInitialState()
    func requestSomething(request: VM.GalleryAppS1.Something.Request)
}

//
// MARK: - Presenter (Presentation Logic)
//

protocol GalleryAppS1PresentationLogicProtocol: BasePresenterVIPProtocol {
    // Naming convention : func present__XXX__(response: VM.GalleryAppS1.__XXX__.Response)
    func presentScreenInitialState(response: VM.GalleryAppS1.ScreenInitialState.Response)
    func presentSomething(response: VM.GalleryAppS1.Something.Response)
}

//
// MARK: - ViewController (Display Logic)
//

protocol GalleryAppS1DisplayLogicProtocol: BaseViewControllerVIPProtocol {
    // Naming convention : func display__XXX__(viewModel: VM.GalleryAppS1.__XXX__.ViewModel)
    func displayScreenInitialState(viewModel: VM.GalleryAppS1.ScreenInitialState.ViewModel)
    func displaySomething(viewModel: VM.GalleryAppS1.Something.ViewModel)
}

//
// MARK: - Router (Routing Logic)
//

// Routing Logic Protocol - all the methods used for routing are kept under this protocol.
protocol GalleryAppS1RoutingLogicProtocol {
    // Naming convention : func routeTo__XXX__MaybeSomeExtraInfo()
    func routeSomewhereWithDataStore()
}

//
// MARK: - DataStore
//

// DataStore : Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
protocol GalleryAppS1DataPassingProtocol {

    // DataStore
    var dsSource: GalleryAppS1DataStoreProtocol? { get }
}

// DataStore : Implemented by the Interactor, and the Router
protocol GalleryAppS1DataStoreProtocol {
    // must have a reference like [var dataStore: GalleryAppS1DataStoreProtocol?]
    var dsSomeKindOfModelAThatWillBePassedToOtherRouter: SomeRandomModelA? { get set }
    var dsSomeKindOfModelBThatWillBePassedToOtherRouter: SomeRandomModelB? { get set }

}

//
// MARK: - Models
//

// Other Models

extension VM {
    enum GalleryAppS1 {
        enum CellType {
            case cellType1
            case cellType2
        }

        struct Something {
            private init() {}
            struct Request { /* ViewController -> Interactor */
                let tags: [String]
                let page: Int
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
                let someListSectionAElements: [VM.GalleryAppS1.TableItem]
                let someListSectionBElements: [VM.GalleryAppS1.TableItem]
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
                let screenLayout: E.GalleryAppS1View.ScreenLayout
            }
        }
    }
}

extension VM.GalleryAppS1 {
    struct TableItem: IdentifiableType, Hashable {

        public typealias Identity = VM.GalleryAppS1.CellType
        public var identity: VM.GalleryAppS1.CellType { return cellType }

        let enabled: Bool
        let image: String
        let title: String
        let subtitle: String
        let cellType: VM.GalleryAppS1.CellType

        init(enabled: Bool,
             image: String,
             title: String,
             subtitle: String,
             cellType: VM.GalleryAppS1.CellType) {
            self.enabled = enabled
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.cellType = cellType
        }
    }
}
