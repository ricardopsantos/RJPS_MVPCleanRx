//
//  P.CartTrackMapPresenter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
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
    class CartTrackMapPresenter: BasePresenterVIP {
        weak var viewController: (CartTrackMapDisplayLogicProtocol)?

        override weak var baseViewController: BaseViewControllerVIPProtocol? {
            return viewController
        }
    }
}

// MARK: PresentationLogicProtocol

extension P.CartTrackMapPresenter {

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

extension P.CartTrackMapPresenter: CartTrackMapPresentationLogicProtocol {

    // Used By Interactor (exclusively)
    func presentScreenInitialState(response: VM.CartTrackMap.ScreenInitialState.Response) {
        let viewModel = VM.CartTrackMap.ScreenInitialState.ViewModel()
        viewController?.displayScreenInitialState(viewModel: viewModel)
    }

    // Used By Interactor (exclusively)
    func presentUserInfo(response: VM.CartTrackMap.UserInfo.Response) {
        let viewModel = VM.CartTrackMap.UserInfo.ViewModel(subTitle: "Hi", list: response.list)
        viewController?.displayUserInfo(viewModel: viewModel)
    }

}
