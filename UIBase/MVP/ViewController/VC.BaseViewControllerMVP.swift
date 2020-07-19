//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RJPSLib
import RxCocoa
import ToastSwiftFramework
//
import DevTools
import Extensions
import AppTheme
import AppConstants
import AppResources
import PointFreeFunctions
import Domain

open class BaseViewControllerMVP: BaseViewController, BaseViewControllerMVPProtocol {

    deinit {
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { DevTools.Log.log("\(self.className) was killed") }
        NotificationCenter.default.removeObserver(self)
    }

    public var presentationStyle: ViewControllerPresentedLike?

    public init(presentationStyle: ViewControllerPresentedLike) {
        super.init(nibName: nil, bundle: nil)
        self.presentationStyle = presentationStyle
    }

    private init() {
        fatalError("Use instead [init(presentationStyle: E.ViewControllerPresentedLike)]")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Use instead [init(presentationStyle: \(ViewControllerPresentedLike.self)]")
    }
    
    public static var shared = BaseViewControllerMVP()

    var keyboardIsVisible = false

    private var lblReachabilityDistanceFromTop: NSLayoutConstraint?
    private var lblReachabilityHeight: CGFloat = 25
    private var margin: CGFloat = 20
    private var stats: Stats?

    open override func loadView() {
        super.loadView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.executeWithDelay(delay: 0.1) { [weak self] in
            guard let self = self else { return }
            self.addStatsView()
        }
    }

    open func displayMessage(_ message: String, type: AlertType) {
        var style = ToastStyle()
        style.cornerRadius = 5
        style.displayShadow = true
        style.messageFont = AppFonts.regular(size: .regularBig)
        switch type {
        case .success: style.backgroundColor = AppColors.success.withAlphaComponent(FadeType.superLight.rawValue)
        case .warning: style.backgroundColor = AppColors.warning.withAlphaComponent(FadeType.superLight.rawValue)
        case .error: style.backgroundColor = AppColors.error.withAlphaComponent(FadeType.superLight.rawValue)
        }
        style.messageColor = .white
        DevTools.topViewController()?.view.makeToast(message, duration: 5, position: .top, style: style)
    }
    
    open func setNoConnectionViewVisibility(to: Bool, withMessage: String = Messages.noInternet.localised) {
        DevTools.assert(false, message: "Deprecated")
    }
    
    func keyboardDidShow() { }
    func keyboardDidHide() { }
    func dismissKeyboard() { }

    private func doViewLifeCycle() {
        prepareLayoutCreateHierarchy()           // DONT CHANGE ORDER
        prepareLayoutBySettingAutoLayoutsRules() // DONT CHANGE ORDER
        prepareLayoutByFinishingPrepareLayout()  // DONT CHANGE ORDER
        setupViewUIRx()                          // DONT CHANGE ORDER
    }

}

//
// MARK: - loadingViewable
//

public extension BaseViewControllerMVP {
    func setActivityState(_ state: Bool) {
        if state {
            self.view.rjs.startActivityIndicator()
        } else { self.view.rjs.stopActivityIndicator() }
    }
}

//
// MARK: - Private stuff
//

extension BaseViewControllerMVP {

    private func addStatsView() {
        guard DevTools.FeatureFlag.devTeam_showStats.isTrue else { return }
        guard self.stats == nil else { return }
        self.stats = Stats()//frame: CGRect(x: 20, y: 40, width: 100.0, height: 60.0))
        self.view.addSubview(self.stats!)
        self.stats?.autoLayout.trailingToSuperview(offset: 20)
        self.stats?.autoLayout.bottomToSuperview(offset: 40)
        self.stats?.autoLayout.width(100)
        self.stats?.addShadow()
        self.stats?.addCorner(radius: 5)
    }
}
