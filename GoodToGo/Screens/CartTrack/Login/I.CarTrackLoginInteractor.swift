//
//  I.CarTrackLoginInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
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
import UIBase
import AppResources

//
// Interactor will fetch the Domain objects, (from DataManager or WebAPI) and return that response
// to the Presenter. The Presenter will parse then into ViewModel objects
//
// The interactor contains your app’s business logic. The user taps and swipes in your UI in
// order to interact with your app. The view controller collects the user inputs from the UI
// and passes it to the interactor. It then retrieves some models and asks some workers to do the work.
//

extension I {
    class CarTrackLoginInteractor: BaseInteractorVIP, CarTrackLoginDataStoreProtocol {

        var presenter: CarTrackLoginPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        private var password: String?
        private var userName: String?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.CarTrackLoginInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        let storedUsername = ""
        let password = ""
        let response = VM.CarTrackLogin.ScreenInitialState.Response(userName: storedUsername, password: password)
        presenter?.presentScreenInitialState(response: response)
        presenter?.presentNextButtonState(response: VM.CarTrackLogin.NextButtonState.Response(isEnabled: false))
    }

}

// MARK: Private Stuff

extension I.CarTrackLoginInteractor {
    private func presentNextButtonState() {
        guard let password = password, let userName = userName else { return }
        let passwordIsValidInShape = password.count >= 5
        let emailIsValidInShape    = userName.isValidEmail
        let userCanTryToContinue   = emailIsValidInShape && passwordIsValidInShape
        self.presenter?.presentNextButtonState(response: VM.CarTrackLogin.NextButtonState.Response(isEnabled: userCanTryToContinue))
    }
}

// MARK: BusinessLogicProtocol

extension I.CarTrackLoginInteractor: CarTrackLoginBusinessLogicProtocol {

    func requestLogin(request: VM.CarTrackLogin.Login.Request) {
        guard let username = userName, let password = password else {
            return
        }
        func routeToNext() {
            presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
            let response = VM.CarTrackLogin.Login.Response(success: true)
            presenter?.presentLogin(response: response)
        }
        func presentError() {
            // This logic message should be on the presenter!
            presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
            let response = BaseDisplayLogicModels.Error(title: "", message: Messages.invalidUserCrededentials.localised)
            presenter?.presentError(response: response)
        }
        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true, message: Messages.alert.localised))
        CarTrackResolver.shared.genericBusiness?.validate(user: username,
                                                          password: password,
                                                          completionHandler: { (result) in
                                                            switch result {
                                                            case .success(let isValid): if isValid { routeToNext() } else { presentError() }
                                                            case .failure: presentError()
                                                            }
        })
    }

    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    func requestScreenState(request: VM.CarTrackLogin.ScreenState.Request) {

        password = request.password
        userName = request.userName

        let passwordIsSelected = request.txtUsernameIsFirstResponder
        let userNameIsSelected = request.txtPasswordIsFirstResponder
        let emailIsEmpty       = userName!.trim.count == 0
        let passwordIsEmpty    = password!.trim.count == 0

        func isValid(somePassword: String) -> Bool {
            return somePassword.count >= 5
        }
        var response: VM.CarTrackLogin.ScreenState.Response?

        if emailIsEmpty && passwordIsEmpty {
            //
            // Booth fields are empty...
            //
            response = VM.CarTrackLogin.ScreenState.Response(emailIsValid: true, passwordIsValid: true)
        } else if passwordIsSelected {
            //
            // Password is being edited
            //
            let usernameIsValid = emailIsEmpty ? true : userName!.isValidEmail // if not empty, perform validation
            let passwordIsValid = isValid(somePassword: password!) || passwordIsEmpty
            response = VM.CarTrackLogin.ScreenState.Response(emailIsValid: usernameIsValid, passwordIsValid: passwordIsValid)
        } else if userNameIsSelected {
            //
            // Username is being edited
            //
            let passwordIsValid = passwordIsEmpty ? true : isValid(somePassword: password!)  // if not empty, perform validation
            let usernameIsValid    = userName!.isValidEmail || emailIsEmpty
            response = VM.CarTrackLogin.ScreenState.Response(emailIsValid: usernameIsValid, passwordIsValid: passwordIsValid)
        } else {
            //
            // None of the fields are being edited
            //
            let emailIsValid    = emailIsEmpty ? true : userName!.isValidEmail               // if not empty, perform validation
            let passwordIsValid = passwordIsEmpty ? true : isValid(somePassword: password!)  // if not empty, perform validation
            response = VM.CarTrackLogin.ScreenState.Response(emailIsValid: emailIsValid, passwordIsValid: passwordIsValid)
        }
        if let response = response {
            self.presenter?.presentScreenState(response: response)
        }
        presentNextButtonState()
    }

}
