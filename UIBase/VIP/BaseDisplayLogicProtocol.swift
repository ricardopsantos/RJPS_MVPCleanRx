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

// All interactors must implement this
public protocol InteratorMandatoryBusinessLogicProtocol {
    func requestScreenInitialState()
}

// [BasePresentationLogicProtocol] && [BaseDisplayLogicProtocol] must match
public protocol BasePresentationLogicProtocol: class {
    func presentLoading(response: BaseDisplayLogicModels.Loading)
    func presentError(response: BaseDisplayLogicModels.Error)
    func displayStatus(response: BaseDisplayLogicModels.Status)
}
