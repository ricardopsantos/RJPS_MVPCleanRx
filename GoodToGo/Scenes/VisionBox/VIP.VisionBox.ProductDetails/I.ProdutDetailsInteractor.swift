//
//  I.ProdutDetailsInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
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
    class ProdutDetailsInteractor: BaseInteractorVIP, ProductDetailsDataStoreProtocol {
        deinit {
            DevTools.Log.logDeInit("\(ProdutDetailsInteractor.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        var presenter: ProductDetailsPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }
        var dsProduct: VisionBox.ProductModel?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.ProdutDetailsInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        var response: VM.ProductDetails.ScreenInitialState.Response!
        response = VM.ProductDetails.ScreenInitialState.Response(productDetails: dsProduct!,
                                                                 userAvatarImage: "",
                                                                 userAvatarName: "",
                                                                 productsList: [])
        presenter?.presentScreenInitialState(response: response)
    }

}

// MARK: Private Stuff

extension I.ProdutDetailsInteractor {

}

// MARK: BusinessLogicProtocol

extension I.ProdutDetailsInteractor: ProductDetailsBusinessLogicProtocol {

}

// MARK: Utils {

extension I.ProdutDetailsInteractor {
    func presentError(error: Error) {
        let response = BaseDisplayLogicModels.Error(title: error.localisedMessageForView)
        basePresenter?.presentError(response: response)
    }
}
