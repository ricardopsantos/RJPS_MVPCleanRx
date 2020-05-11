//
//  InteratorMandatoryBusinessLogicProtocol.swift
//  UIBase
//
//  Created by Ricardo Santos on 11/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// All interactors must implement this
public protocol BaseInteractorVIPMandatoryBusinessLogicProtocol {
    var basePresenter: BasePresenterVIPProtocol! { get }
    func requestScreenInitialState()
}
