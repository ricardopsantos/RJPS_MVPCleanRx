//
//  P.CarTrackLoginPresenter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
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
    class CarTrackLoginPresenter: BasePresenterVIP {
        weak var viewController: (CarTrackLoginDisplayLogicProtocol)?

        override weak var baseViewController: BaseViewControllerVIPProtocol? {
            return viewController
        }
    }
}

// MARK: PresentationLogicProtocol

extension P.CarTrackLoginPresenter {

}

// MARK: PresentationLogicProtocol

extension P.CarTrackLoginPresenter: CarTrackLoginPresentationLogicProtocol {
    func presentNextButtonState(response: VM.CarTrackLogin.NextButtonState.Response) {
        let viewModel = VM.CarTrackLogin.NextButtonState.ViewModel(isEnabled: response.isEnabled)
        viewController?.displayNextButtonState(viewModel: viewModel)
    }

    // Used By Interactor (exclusively)
    func presentScreenInitialState(response: VM.CarTrackLogin.ScreenInitialState.Response) {
        let userName = response.userName
        let password = response.password
        let screenLayout: E.CarTrackLoginView.ScreenLayout = .enterUserCredentials
        let title = Messages.welcome.localised
        let viewModel = VM.CarTrackLogin.ScreenInitialState.ViewModel(title: title,
                                                                      userName: userName,
                                                                      password: password,
                                                                      screenLayout: screenLayout)
        viewController?.displayScreenInitialState(viewModel: viewModel)
    }

    // Used By Interactor (exclusively)
    func presentScreenState(response: VM.CarTrackLogin.ScreenState.Response) {

        var layout: E.CarTrackLoginView.ScreenLayout = .enterUserCredentials
        let fieldsHaveValues = response.emailIsNotEmpty || response.passwordIsNotEmpty
        let invalidEmail    = !response.emailIsValidInShape && !response.emailIsNotEmpty
        let invalidPassword = !response.emailIsValidInShape && !response.emailIsNotEmpty
        if fieldsHaveValues {
            if invalidPassword && !invalidEmail {
                // Invalid password
                layout = .invalidPasswordFormat(errorMessage: Messages.invalidPassword.localised)
            } else if !invalidPassword && invalidEmail {
                // Invalid email
                layout = .invalidEmailFormat(errorMessage: Messages.invalidEmail.localised)
            } else if !invalidPassword && !invalidEmail {
                // Invalid email and password
                layout = .invalidEmailFormatAndPasswordFormat(passwordErrorMessage: Messages.invalidPassword.localised, emailErrorMessage: Messages.invalidEmail.localised)
            } else {
                layout = .allFieldsAreValid
            }
        } else {
            layout = .enterUserCredentials
        }
        let viewModel = VM.CarTrackLogin.ScreenState.ViewModel(layout: layout)
        viewController?.displayScreenState(viewModel: viewModel)

    }

}
