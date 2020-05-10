//
//  BasePresenterVIP.swift
//  UIBase
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public struct ErrorModel {
    public let title: String
    public let message: String
    public var shouldDisplay: Bool = true

    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    public init(error: Swift.Error) {
        self.title = "Error"
        self.message = error.localizedDescription
    }
}

public struct LoadingModel {
    public let isLoading: Bool
    public let message: String

    public init(error: Error) {
        self.isLoading = false
        self.message = "\(error)"
    }

    public init(isLoading: Bool, message: String) {
        self.isLoading = isLoading
        self.message = message
    }
}

public protocol BaseDisplayLogicProtocol: class {
    func displayLoading(viewModel: LoadingModel)
    func displayError(viewModel: ErrorModel)
    //func displayToast(viewModel: i9.Toast.ViewModel, position: ToastPosition, completion: ((Bool) -> Void)?)
}

open class BasePresenterVIP {
    open func baseDisplayLogicImpl() -> BaseDisplayLogicProtocol? {
        assert(false)
        return nil
    }
    deinit {
        AppLogger.log("\(self) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    public init () {}
}
