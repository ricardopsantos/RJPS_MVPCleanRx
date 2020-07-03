//
//  P.ProdutsListPresenter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import AppResources
import UIBase

//
// After the interactor produces some results, it passes the response to the presenter.
// The presenter then marshal the response into view models suitable for display.
// It then passes the view models back to the view controller for display to the user.
//
// Now that we have the Response from the Interactor, it’s time to format it
// into a ViewModel and pass the result back to the ViewController. Presenter will be
// in charge of the presentation logic. This component decides how the data will be presented to the user.
//

extension P {
    class ProdutsListPresenter: BasePresenterVIP {
        deinit {
            DevTools.Log.logDeInit("\(ProdutsListPresenter.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var viewController: (ProdutsListDisplayLogicProtocol)?

        override weak var baseViewController: BaseViewControllerVIPProtocol? {
            return viewController
        }
    }
}

// MARK: PresentationLogicProtocol

extension P.ProdutsListPresenter {

    //
    // Do you need to override this? Its allready implemented on a Protocol Extension
    //
    /*
    func presentStatus(response: BaseDisplayLogicModels.Status) {
        let viewModel = response
        baseDisplayLogic?.displayStatus(viewModel: viewModel)
    }

    func presentError(response: BaseDisplayLogicModels.Error) {
        let viewModel = response
        baseDisplayLogic?.displayError(viewModel: viewModel)
    }

    func presentLoading(response: BaseDisplayLogicModels.Loading) {
        let viewModel = response
        baseDisplayLogic?.displayLoading(viewModel: viewModel)
    }*/
}

// MARK: PresentationLogicProtocol

extension P.ProdutsListPresenter: ProdutsListPresentationLogicProtocol {

    // Used By Interactor (exclusively)
    func presentScreenInitialState(response: VM.ProdutsList.ScreenInitialState.Response) {
        let title = response.title.uppercased()
        let subTitle = response.subTitle.lowercased()
        let viewModel = VM.ProdutsList.ScreenInitialState.ViewModel(title: title,
                                                                                 subTitle: subTitle,
                                                                                 screenLayout: .layoutA)
        viewController?.displayScreenInitialState(viewModel: viewModel)
    }

    // Used By Interactor (exclusively)
    func presentSomething(response: VM.ProdutsList.Something.Response) {
        // Presenter will transform response object in something that the View can process/read
        let subTitle = response.subTitle.uppercased()
        let someListA = response.listA
            .map { VM.ProdutsList.TableItem(enabled: true,
                                                  image: Images.noInternet.rawValue,
                                                  title: $0.id ?? "N.A.",
                                                  subtitle: $0.state?.uppercased() ?? "N.A.",
                                                  cellType: .cellType1)
            }
        let someListB = response.listB
            .map { VM.ProdutsList.TableItem(enabled: true,
                                                         image: Images.noInternet.rawValue,
                                                  title: $0.id ?? "N.A.",
                                                  subtitle: $0.state?.uppercased() ?? "N.A.",
                                                  cellType: .cellType2)
            }
        let sum = someListA.count + someListB.count
        let viewModel = VM.ProdutsList.Something.ViewModel(subTitle: subTitle,
                                                                        someValue: "\(sum)",
            someListSectionATitle: "\(someListA.count) A elements",
            someListSectionBTitle: "\(someListB.count) B elements",
            someListSectionAElements: someListA,
            someListSectionBElements: someListB)
        viewController?.displaySomething(viewModel: viewModel)
    }

}
