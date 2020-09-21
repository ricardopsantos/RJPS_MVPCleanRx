//
//  GoodToGo
//
//  Created by Ricardo Santos on 11/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RJPSLib_Base
import ToastSwiftFramework
import RxSwift
import DevTools
//
import AppConstants

open class BaseViewControllerVIP: UIViewController, BaseViewControllerVIPProtocol {

    public var presentationStyle: VCPresentationStyle?
    public init(presentationStyle: VCPresentationStyle) {
        super.init(nibName: nil, bundle: nil)
        self.presentationStyle = presentationStyle
    }

    private init() {
        fatalError("Use instead [init(presentationStyle: ViewControllerPresentedLike)]")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Use instead [init(presentationStyle: \(VCPresentationStyle.self)]")
    }

    deinit {
        DevTools.Log.logDeInit("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }

    public static var shared = BaseViewControllerVIP(presentationStyle: .unknown)

    open override func loadView() {
        super.loadView()
        setupColorsAndStyles()
    }

    open func displayStatus(viewModel: BaseDisplayLogicModels.Status) {
        var message = "\(viewModel.title)"
        if !viewModel.message.isEmpty {
            message = message.isEmpty ? viewModel.message : "\(message)\n\n\(viewModel.message)"
        }
        displayMessage(message, type: .success)
    }

    open func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
        setActivityState(viewModel.isLoading)
    }

    open func displayError(viewModel: BaseDisplayLogicModels.Error) {
        var message = "\(viewModel.title)"
        if !viewModel.message.isEmpty {
            message = message.isEmpty ? viewModel.message : "\(message)\n\n\(viewModel.message)"
        }
        displayMessage(message, type: .error)
    }

    open func setupColorsAndStyles() {
        DevTools.Log.error(DevTools.Strings.notImplemented)
    }
}

private extension BaseViewControllerVIP {
    func displayMessage(_ message: String, type: AlertType) {
        var style = ToastStyle()
        style.cornerRadius = 5
        style.displayShadow = true
        style.messageFont = AppFonts.Styles.paragraphSmall.rawValue
        switch type {
        case .success: style.backgroundColor = AppColors.success.withAlphaComponent(FadeType.superLight.rawValue)
        case .warning: style.backgroundColor = AppColors.warning.withAlphaComponent(FadeType.superLight.rawValue)
        case .error: style.backgroundColor = AppColors.error.withAlphaComponent(FadeType.superLight.rawValue)
        }
        style.messageColor = .white
        DevTools.topViewController()?.view.makeToast(message, duration: 5, position: .top, style: style)
    }

    func setActivityState(_ state: Bool) {
        if state {
            self.view.rjs.startActivityIndicator()
        } else { self.view.rjs.stopActivityIndicator() }
    }
}
