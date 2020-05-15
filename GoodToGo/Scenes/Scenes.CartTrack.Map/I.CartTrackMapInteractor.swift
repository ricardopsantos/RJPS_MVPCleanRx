//
//  I.CartTrackMapInteractor.swift
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
    class CartTrackMapInteractor: BaseInteractorVIP, CartTrackMapDataStoreProtocol {

        var presenter: CartTrackMapPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        var list: [Domain.CarTrack.UserModel] = []
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.CartTrackMapInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        let response = VM.CartTrackMap.ScreenInitialState.Response()
        presenter?.presentScreenInitialState(response: response)
    }

}

// MARK: Private Stuff

extension I.CartTrackMapInteractor {

}

// MARK: BusinessLogicProtocol

extension I.CartTrackMapInteractor: CartTrackMapBusinessLogicProtocol {

    func requestMapDataFilter(viewModel: VM.CartTrackMap.MapDataFilter.Request) {
        if viewModel.filter.count > 0 {
            let filtered = self.list.filter { (some) -> Bool in
                let c1 = some.company.name.contains(subString: viewModel.filter)
                let c2 = some.name.contains(subString: viewModel.filter)
                return c1 || c2
            }
            let response = VM.CartTrackMap.MapData.Response(list: filtered)
            self.presenter?.presentMapData(response: response)
        } else if list.count > 0 {
            let response = VM.CartTrackMap.MapData.Response(list: list)
            self.presenter?.presentMapData(response: response)
        }
    }

    func requestMapData(request: VM.CartTrackMap.MapData.Request) {

        #warning("dont use bind. use asObservable")
        presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: true))
        CarTrackResolver.shared.api?
            .getUserDetailV3(cacheStrategy: .cacheAndLatestValue)
            .asObservable().bind(onNext: { [weak self] (result) in
                self?.presenter?.presentLoading(response: BaseDisplayLogicModels.Loading(isLoading: false))
                guard let self = self else { return }
                switch result {
                case .success(let elements):
                    self.list = elements.map({ $0.toDomain! })
                    let response = VM.CartTrackMap.MapData.Response(list: self.list)
                    self.presenter?.presentMapData(response: response)
                case .failure:
                    self.presenter?.presentErrorGeneric()
                }
            }).disposed(by: disposeBag)
    }

}
