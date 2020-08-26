//
//  I.GalleryAppS1Interactor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
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
import Domain_GalleryApp

//
// Interactor will fetch the Domain objects, and return that response
// to the Presenter. The Presenter will parse then into ViewModel objects
//
// The interactor contains your app’s business logic. The user taps and swipes in your UI in
// order to interact with your app. The view controller collects the user inputs from the UI
// and passes it to the interactor. It then retrieves some models and asks some workers to do the work.
//

extension I {
    class GalleryAppS1Interactor: BaseInteractorVIP, GalleryAppS1DataStoreProtocol {

        deinit {
            DevTools.Log.logDeInit("\(GalleryAppS1Interactor.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        var presenter: GalleryAppS1PresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }
        var worker = GalleryAppResolver.shared.worker

        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelAThatWillBePassedToOtherRouter: SomeRandomModelA?
        var dsSomeKindOfModelBThatWillBePassedToOtherRouter: SomeRandomModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.GalleryAppS1Interactor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        var response: VM.GalleryAppS1.ScreenInitialState.Response!
        response = VM.GalleryAppS1.ScreenInitialState.Response(title: "Template Scene 1", subTitle: "Tap one of the buttons")
        presenter?.presentScreenInitialState(response: response)

        // Update DataStore // <<-- DS Sample : Take notice
        // When passing Data from the Scene Router to other one, this will be the value that will be passed
        dsSomeKindOfModelAThatWillBePassedToOtherRouter = SomeRandomModelA(s1: "A: \(Date())")
        dsSomeKindOfModelBThatWillBePassedToOtherRouter = SomeRandomModelB(s2: "B: \(Date())")

        self.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
      /*  let request = GalleryAppRequests.Search(tags: ["dog"])
        worker!.search(request, cacheStrategy: .cacheElseLoad).asObservable()
            .subscribe(onNext: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let elements):
                print(elements)
               /* self.list = elements.map({ $0.toDomain! })
                let response = VM.CartTrackMap.MapData.Response(list: self.list)
                self.presenter?.presentMapData(response: response)*/
            case .failure(let error):
                self.presentError(error: error)
            }
        }, onError: { (error) in
            DevTools.Log.error(error)
            self.presentError(error: error)
        }, onCompleted: {
            self.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
        }).disposed(by: disposeBag)*/

    }

}

// MARK: Private Stuff

extension I.GalleryAppS1Interactor {

}

// MARK: BusinessLogicProtocol

extension I.GalleryAppS1Interactor: GalleryAppS1BusinessLogicProtocol {

    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    func requestSomething(request: VM.GalleryAppS1.Something.Request) {

        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
        DispatchQueue.executeWithDelay(delay: 0.5) { [weak self] in
            let mockA1 = TemplateModel(id: "some id 1", state: "state_a - \(Date())")
            let mockA2 = TemplateModel(id: "some id 2", state: "state_a - \(Date())")
            let response = VM.GalleryAppS1.Something.Response(listA: [mockA1],
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

extension I.GalleryAppS1Interactor {
    func presentError(error: Error) {
        let response = BaseDisplayLogicModels.Error(title: error.localisedMessageForView)
        basePresenter?.presentError(response: response)
    }
}
