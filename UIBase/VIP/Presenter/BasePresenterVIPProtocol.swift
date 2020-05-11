//
//  BaseDisplay.swift
//  Domain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RxSwift
import RxCocoa
//
import AppResources
import Domain

// [BasePresentationLogicProtocol] && [BaseDisplayLogicProtocol] must match
public protocol BasePresenterVIPProtocol: class {
    var baseDisplayLogic: BaseDisplayLogicProtocol? { get }
    func presentLoading(response: BaseDisplayLogicModels.Loading)
    func presentError(response: BaseDisplayLogicModels.Error)
    func presenStatus(response: BaseDisplayLogicModels.Status)
}

// Default implementation....
public extension BasePresenterVIPProtocol {
    func presenStatus(response: BaseDisplayLogicModels.Status) {
        let viewModel = response
        baseDisplayLogic?.displayStatus(viewModel: viewModel)
    }

    func presentError(response: BaseDisplayLogicModels.Error) {
        let viewModel = response
        baseDisplayLogic?.displayError(viewModel: viewModel)
    }

    func presentLoading(response: BaseDisplayLogicModels.Loading) {
        let viewModel = response
        baseDisplayLogic?.displayLoading(viewModel: viewModel)
    }
}
