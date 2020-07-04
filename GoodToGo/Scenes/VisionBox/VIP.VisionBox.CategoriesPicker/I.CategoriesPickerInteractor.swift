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
        var dsSelectedCategory: VisionBox.Category?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.CategoriesPickerInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        let response = VM.CategoriesPicker.ScreenInitialState.Response()
        presenter?.presentScreenInitialState(response: response)
    }

}

// MARK: Private Stuff

extension I.CategoriesPickerInteractor {

}

// MARK: BusinessLogicProtocol

extension I.CategoriesPickerInteractor: CategoriesPickerBusinessLogicProtocol {

    func requestCategoryChange(request: VM.CategoriesPicker.CategoryChange.Request) {
        dsSelectedCategory = request.category
        let response = VM.CategoriesPicker.CategoryChange.Response()
        self.presenter?.presentCategoryChange(response: response)
    }

}

// MARK: Utils {

extension I.CategoriesPickerInteractor {
    func presentError(error: Error) {
        let response = BaseDisplayLogicModels.Error(title: error.localisedMessageForView)
        basePresenter?.presentError(response: response)
    }
}
