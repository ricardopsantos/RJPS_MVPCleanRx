//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
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

//
// Interactor will fetch the Domain objects, (from DataManager or WebAPI) and return that response
// to the Presenter. The Presenter will parse then into ViewModel objects
//
// The interactor contains your app’s business logic. The user taps and swipes in your UI in
// order to interact with your app. The view controller collects the user inputs from the UI
// and passes it to the interactor. It then retrieves some models and asks some workers to do the work.
//

extension I {
    class ___VARIABLE_sceneName___Interactor: BaseInteractorVIP, ___VARIABLE_sceneName___DataStoreProtocol {

        var presenter: ___VARIABLE_sceneName___PresentationLogicProtocol?
        var basePresenter: BasePresenterVIPProtocol! { return presenter }

        // DataStoreProtocol Protocol vars...
        var dsSomeEntityModel: ___VARIABLE_sceneName___Auxiliary__SomeEntityModel?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.___VARIABLE_sceneName___Interactor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        var response: VM.___VARIABLE_sceneName___.ScreenInitialState.Response!
        if let dataPassing = dsSomeEntityModel {
            // Some data was passed via Router, lets use it...
            let title = "Template Scene 2"
            let subTitle = "Some data was passed!\nScroll me\n\n\n\n\n\(dataPassing)\n\n\n"
            response = VM.___VARIABLE_sceneName___.ScreenInitialState.Response(title: title,
                                                                               subTitle: subTitle)
        } else {
            response = VM.___VARIABLE_sceneName___.ScreenInitialState.Response(title: "Template Scene 1",
                                                                               subTitle: "Tap one of the buttons")
        }
        presenter?.presentScreenInitialState(response: response)

        // Update Model for future use
        dsSomeEntityModel = ___VARIABLE_sceneName___Auxiliary__SomeEntityModel(value: "Passed via DataStoreProtocol @ \(Date())")

        requestSomeStuff(request: VM.___VARIABLE_sceneName___.SomeStuff.Request(userId: ""))
    }

}

// MARK: Private Stuff

extension I.___VARIABLE_sceneName___Interactor {

}

// MARK: BusinessLogicProtocol

extension I.___VARIABLE_sceneName___Interactor: ___VARIABLE_sceneName___BusinessLogicProtocol {

    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    func requestSomeStuff(request: VM.___VARIABLE_sceneName___.SomeStuff.Request) {

        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true, message: ""))
        presenter?.presentError(response: BaseDisplayLogicModels.Error(title: "asd", message: "asd"))
        presenter?.presenStatus(response: BaseDisplayLogicModels.Status(message: "123123"))
        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true, message: ""))
        DispatchQueue.executeWithDelay(delay: 1) { [weak self] in
            let mockA1 = TemplateModel(id: "some id 1", state: "state_a - \(Date())")
            let response = VM.___VARIABLE_sceneName___.SomeStuff.Response(listA: [mockA1],
                                                                          listB: [mockA1],
                                                                          subTitle: "New subtitle \(Date())")
            self?.presenter?.presentSomeStuff(response: response)
            self?.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false, message: ""))
        }
    }

}
