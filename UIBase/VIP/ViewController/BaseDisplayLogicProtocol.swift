//
//  BaseDisplayLogicProtocol.swift
//  UIBase
//
//  Created by Ricardo Santos on 11/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public struct BaseDisplayLogicModels {

    public struct Error {
        public let title: String
        public let message: String
        public var shouldDisplay: Bool = true
        public init(title: String, message: String="") {
            self.title = title
            self.message = message
        }
    }

    public struct Status {
        public let title: String
        public let message: String
        public init(title: String="", message: String="") {
            self.title = title
            self.message = message
        }
    }

    public struct Loading {
        public let isLoading: Bool
        public let message: String
        public init(isLoading: Bool, message: String="") {
            self.isLoading = isLoading
            self.message = message
        }
    }
}

public protocol BaseViewControllerVIPProtocol: class {
    func displayLoading(viewModel: BaseDisplayLogicModels.Loading)
    func displayError(viewModel: BaseDisplayLogicModels.Error)
    func displayStatus(viewModel: BaseDisplayLogicModels.Status)
}