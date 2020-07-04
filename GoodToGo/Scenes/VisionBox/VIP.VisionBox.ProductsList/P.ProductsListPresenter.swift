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

extension P.ProdutsListPresenter: ProdutsListPresentationLogicProtocol {

    // Used By Interactor (exclusively)
    func presentScreenInitialState(response: VM.ProductsList.ScreenInitialState.Response) {
        let viewModel = VM.ProductsList.ScreenInitialState.ViewModel(products: response.products)
        viewController?.displayScreenInitialState(viewModel: viewModel)
    }

    // Used By Interactor (exclusively)
    func presentSomething(response: VM.ProductsList.Something.Response) {
        let viewModel = VM.ProductsList.Something.ViewModel(products: response.products)
        viewController?.displaySomething(viewModel: viewModel)
    }

}
