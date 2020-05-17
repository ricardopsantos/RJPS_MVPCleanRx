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
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self.className) was killed") }
        NotificationCenter.default.removeObserver(self)
    }

    public static var shared = BaseViewControllerVIP()

    open override func loadView() {
        super.loadView()
        setupColorsAndStyles()
    }

    open func displayStatus(viewModel: BaseDisplayLogicModels.Status) {
        BaseViewControllerMVP.shared.displayMessage(viewModel.message, type: .success)
    }

    open func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
        BaseViewControllerMVP.shared.setActivityState(viewModel.isLoading)
    }

    open func displayError(viewModel: BaseDisplayLogicModels.Error) {
        BaseViewControllerMVP.shared.displayMessage(viewModel.message, type: .error)
    }

    open func setupColorsAndStyles() {
        AppLogger.error(DevTools.Strings.notImplemented)
    }
}
