//
//  I.CarTrackUsersInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/05/2020.
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
    class CarTrackUsersInteractor: BaseInteractorVIP, CarTrackUsersDataStoreProtocol {

        var presenter: CarTrackUsersPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelA: CarTrackUsersDataStoreModelA?
        var dsSomeKindOfModelB: CarTrackUsersDataStoreModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.CarTrackUsersInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        var response: VM.CarTrackUsers.ScreenInitialState.Response!
        if let dataPassing = dsSomeKindOfModelA {
            // Some data was passed via Router, lets use it...
            let title = "Template Scene 2"
            let subTitle = "Some data was passed!\nScroll me\n\n\n\n\n\(dataPassing)\n\n\n"
            response = VM.CarTrackUsers.ScreenInitialState.Response(title: title,
                                                                               subTitle: subTitle)
        } else {
            response = VM.CarTrackUsers.ScreenInitialState.Response(title: "Template Scene 1",
                                                                               subTitle: "Tap one of the buttons")
        }
        presenter?.presentScreenInitialState(response: response)

        // Update Model for future use
        dsSomeKindOfModelA = CarTrackUsersDataStoreModelA(aString: "Passed via DataStoreProtocol @ \(Date())")

        requestSomeStuff(request: VM.CarTrackUsers.SomeStuff.Request(userId: ""))

        CarTrackResolver.shared.api?.getUserDetail(userName: "", canUseCache: true, completionHandler: { (result) in
            switch result {
            case .success(let results):
                print(results)
            case .failure(_):
                _ = ()
            }
        })
    }

}

// MARK: Private Stuff

extension I.CarTrackUsersInteractor {

}

// MARK: BusinessLogicProtocol

extension I.CarTrackUsersInteractor: CarTrackUsersBusinessLogicProtocol {

    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    func requestSomeStuff(request: VM.CarTrackUsers.SomeStuff.Request) {

        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
        DispatchQueue.executeWithDelay(delay: 3) { [weak self] in
            let mockA1 = TemplateModel(id: "some id 1", state: "state_a - \(Date())")
            let mockA2 = TemplateModel(id: "some id 2", state: "state_a - \(Date())")
            let response = VM.CarTrackUsers.SomeStuff.Response(listA: [mockA1],
                                                                          listB: [mockA2],
                                                                          subTitle: "New subtitle \(Date())")
            self?.presenter?.presentSomeStuff(response: response)
            self?.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
            //self?.presenter?.presentError(response: BaseDisplayLogicModels.Error(title: "Messages.error.localised, message: "Error message"))
            self?.presenter?.presentStatus(response: BaseDisplayLogicModels.Status(message: Messages.success.localised))
        }
    }

}
