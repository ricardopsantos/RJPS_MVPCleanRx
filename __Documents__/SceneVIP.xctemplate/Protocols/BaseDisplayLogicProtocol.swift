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
import UIBase

// All interators must implement this
public protocol InteratorMandatoryBusinessLogicProtocol {
    func requestScreenInitialState()
}

public protocol BasePresentationLogicProtocol: class {
    func presentLoading(response: LoadingModel)
    func presentError(response: ErrorModel)
}

open class BaseInteractor {
    public var disposeBag = DisposeBag()
    public init() { }
}
