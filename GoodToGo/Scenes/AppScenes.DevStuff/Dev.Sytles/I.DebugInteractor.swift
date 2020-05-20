//
//  I.StylesInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
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
    class DebugInteractor: BaseInteractorVIP, DebugDataStoreProtocol {

        var presenter: DebugPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelA: DebugDataStoreModelA?
        var dsSomeKindOfModelB: DebugDataStoreModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.DebugInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {

    }

}

// MARK: Private Stuff

extension I.DebugInteractor {

}

// MARK: BusinessLogicProtocol

extension I.DebugInteractor: DebugBusinessLogicProtocol {

    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    func requestSomeStuff(request: VM.Debug.SomeStuff.Request) {

    }

}
