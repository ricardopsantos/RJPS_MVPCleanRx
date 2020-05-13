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
        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelA: CarTrackLoginDataStoreModelA?
        var dsSomeKindOfModelB: CarTrackLoginDataStoreModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.CarTrackLoginInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        let storedUsername = "ricardo"
        let response = VM.CarTrackLogin.ScreenInitialState.Response(userName: storedUsername, password: "")
        presenter?.presentScreenInitialState(response: response)
        presenter?.presentNextButtonState(response: VM.CarTrackLogin.NextButtonState.Response(isEnabled: false))
    }

}

// MARK: Private Stuff

extension I.CarTrackLoginInteractor {

}

// MARK: BusinessLogicProtocol

extension I.CarTrackLoginInteractor: CarTrackLoginBusinessLogicProtocol {

    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    func requestScreenState(request: VM.CarTrackLogin.ScreenState.Request) {

        password = request.password
        userName = request.userName

        let passwordIsSelected     = request.txtUsernameIsFirstResponder
        let userNameIsSelected     = request.txtPasswordIsFirstResponder
        let passwordIsValidInShape = password!.count >= 5 && !passwordIsSelected
        let emailIsValidInShape    = userName!.isValidEmail && !userNameIsSelected
        let emailIsNotEmpty        = userName!.count > 0
        let passwordIsNotEmpty     = password!.count > 0
        let response = VM.CarTrackLogin.ScreenState.Response(passwordIsValidInShape: passwordIsValidInShape,
                                                             emailIsValidInShape: emailIsValidInShape,
                                                             emailIsNotEmpty: emailIsNotEmpty,
                                                             passwordIsNotEmpty: passwordIsNotEmpty)
        self.presenter?.presentScreenState(response: response)
        let userCanTryToContinue = emailIsValidInShape && passwordIsValidInShape
        self.presenter?.presentNextButtonState(response: VM.CarTrackLogin.NextButtonState.Response(isEnabled: userCanTryToContinue))
    }

}
