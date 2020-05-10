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

public enum ErrorType {
    case someError
}

public protocol BaseDataStoreProtocol {
    var errorType: ErrorType? { get }
}

// All interators must implement this
public protocol InteratorMandatoryBusinessLogicProtocol {
    func requestScreenInitialState()
}

open class BaseInteractorWithWorkers: BaseInteractor {
    // All workers
    //let workerDashboard: DashboardWorker = DashboardWorker()
}

public protocol BasePresentationLogicProtocol: class {
    func presentLoading(response: LoadingModel)
    func presentError(response: ErrorModel)
}

public protocol BaseBusinessLogicProtocol {

}

open class BaseInteractor {
    public var errorType: AppCodes?
    public var disposeBag = DisposeBag()

    public init() {}

    open func basePresentationLogicImpl() -> BasePresentationLogicProtocol? {
        assert(false)
        return nil
    }

    open func presentError(error: Error) {
        let response = ErrorModel(error: error)
        basePresentationLogicImpl()?.presentError(response: response)
    }

    open func presentLoading(isLoading: Bool, message: String = "") {
        let response = LoadingModel(isLoading: isLoading, message: message)
        basePresentationLogicImpl()?.presentLoading(response: response)
    }
}
