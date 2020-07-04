//
//  I.CategoriesPickerInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
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
import Factory

//
// Interactor will fetch the Domain objects, (from DataManager or WebAPI) and return that response
// to the Presenter. The Presenter will parse then into ViewModel objects
//
// The interactor contains your app’s business logic. The user taps and swipes in your UI in
// order to interact with your app. The view controller collects the user inputs from the UI
// and passes it to the interactor. It then retrieves some models and asks some workers to do the work.
//

extension I {
    class CategoriesPickerInteractor: BaseInteractorVIP, CategoriesPickerDataStoreProtocol {

        deinit {
            DevTools.Log.logDeInit("\(CategoriesPickerInteractor.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        var presenter: CategoriesPickerPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelAThatWillBePassedToOtherRouter: SomeRandomModelA?
        var dsSomeKindOfModelBThatWillBePassedToOtherRouter: SomeRandomModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.CategoriesPickerInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        var response: VM.CategoriesPicker.ScreenInitialState.Response!
        response = VM.CategoriesPicker.ScreenInitialState.Response(title: "Template Scene 1", subTitle: "Tap one of the buttons")
        presenter?.presentScreenInitialState(response: response)

        // Update DataStore // <<-- DS Sample : Take notice
        // When passing Data from the Scene Router to other one, this will be the value that will be passed
        dsSomeKindOfModelAThatWillBePassedToOtherRouter = SomeRandomModelA(s1: "A: \(Date())")
        dsSomeKindOfModelBThatWillBePassedToOtherRouter = SomeRandomModelB(s2: "B: \(Date())")

    }

}

// MARK: Private Stuff

extension I.CategoriesPickerInteractor {

}

// MARK: BusinessLogicProtocol

extension I.CategoriesPickerInteractor: CategoriesPickerBusinessLogicProtocol {

    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    func requestSomething(request: VM.CategoriesPicker.Something.Request) {

        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
        DispatchQueue.executeWithDelay(delay: 0.5) { [weak self] in
            let mockA1 = TemplateModel(id: "some id 1", state: "state_a - \(Date())")
            let mockA2 = TemplateModel(id: "some id 2", state: "state_a - \(Date())")
            let response = VM.CategoriesPicker.Something.Response(listA: [mockA1],
                                                                          listB: [mockA2],
                                                                          subTitle: "New subtitle \(Date())")
            self?.presenter?.presentSomething(response: response)
            self?.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
            //self?.presenter?.presentError(error: error)
            self?.presenter?.presentStatus(response: BaseDisplayLogicModels.Status(message: Messages.success.localised))
        }
    }

}

// MARK: Utils {

extension I.CategoriesPickerInteractor {
    func presentError(error: Error) {
        let response = BaseDisplayLogicModels.Error(title: error.localisedMessageForView)
        basePresenter?.presentError(response: response)
    }
}
