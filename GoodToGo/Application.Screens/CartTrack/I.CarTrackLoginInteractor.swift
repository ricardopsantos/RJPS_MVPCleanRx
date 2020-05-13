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
        let response = VM.CarTrackLogin.ScreenInitialState.Response(userName: "123", password: "345")
        presenter?.presentScreenInitialState(response: response)
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

        /*
        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
        DispatchQueue.executeWithDelay(delay: 3) { [weak self] in
            let mockA1 = TemplateModel(id: "some id 1", state: "state_a - \(Date())")
            let mockA2 = TemplateModel(id: "some id 2", state: "state_a - \(Date())")
            let response = VM.CarTrackLogin.ValidateNextButtonEnabled.Response(listA: [mockA1],
                                                                          listB: [mockA2],
                                                                          subTitle: "New subtitle \(Date())")
            self?.presenter?.presentSomeStuff(response: response)
            self?.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
            //self?.presenter?.presentError(response: BaseDisplayLogicModels.Error(title: "Messages.error.localised, message: "Error message"))
            self?.presenter?.presentStatus(response: BaseDisplayLogicModels.Status(message: Messages.success.localised))
        }*/
    }

}
