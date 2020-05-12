//
//  BaseGenericViewControllerVIP.swift
//  PointFreeFunctions
//
//  Created by Ricardo Santos on 11/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import DevTools

open class BaseViewControllerVIP: UIViewController, BaseViewControllerVIPProtocol {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open override func loadView() {
        super.loadView()
        setupColorsAndStyles()
    }

    open func displayStatus(viewModel: BaseDisplayLogicModels.Status) {
        DevTools.makeToast(viewModel.message, isError: false)
    }

    open func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
        DevTools.makeToast(viewModel.message, isError: false)
    }

    open func displayError(viewModel: BaseDisplayLogicModels.Error) {
        DevTools.makeToast(viewModel.message, isError: true)
    }

    open func setupColorsAndStyles() {
        AppLogger.error(DevTools.Strings.notImplemented)
    }
}
