//
//  GoodToGo
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

    public var presentationStyle: VCPresentationStyle?
    public init(presentationStyle: VCPresentationStyle) {
        super.init(nibName: nil, bundle: nil)
        self.presentationStyle = presentationStyle
    }

    private init() {
        fatalError("Use instead [init(presentationStyle: E.ViewControllerPresentedLike)]")
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
        BaseViewControllerMVP.shared.displayMessage(message, type: .success)
    }

    open func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
        BaseViewControllerMVP.shared.setActivityState(viewModel.isLoading)
    }

    open func displayError(viewModel: BaseDisplayLogicModels.Error) {
        var message = "\(viewModel.title)"
        if !viewModel.message.isEmpty {
            message = message.isEmpty ? viewModel.message : "\(message)\n\n\(viewModel.message)"
        }
        BaseViewControllerMVP.shared.displayMessage(message, type: .error)
    }

    open func setupColorsAndStyles() {
        DevTools.Log.error(DevTools.Strings.notImplemented)
    }
}
