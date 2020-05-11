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
    var baseViewController: BaseViewControllerVIPProtocol? { get }
    func presentLoading(response: BaseDisplayLogicModels.Loading)
    func presentError(response: BaseDisplayLogicModels.Error)
    func presenStatus(response: BaseDisplayLogicModels.Status)
}

// Default implementation....
public extension BasePresenterVIPProtocol {
    func presenStatus(response: BaseDisplayLogicModels.Status) {
        let viewModel = response
        baseViewController?.displayStatus(viewModel: viewModel)
    }

    func presentError(response: BaseDisplayLogicModels.Error) {
        let viewModel = response
        baseViewController?.displayError(viewModel: viewModel)
    }

    func presentLoading(response: BaseDisplayLogicModels.Loading) {
        let viewModel = response
        baseViewController?.displayLoading(viewModel: viewModel)
    }
}
