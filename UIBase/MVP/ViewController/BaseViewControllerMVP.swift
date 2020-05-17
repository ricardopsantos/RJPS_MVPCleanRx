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

open class BaseViewControllerMVP: UIViewController, BaseViewControllerMVPProtocol {

    deinit {
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self.className) was killed") }
        NotificationCenter.default.removeObserver(self)
    }

    public static var shared = BaseViewControllerMVP()

    public var firstAppearance = true
    //var keyboardHeigthAux: CGFloat = 0
    var keyboardIsVisible = false

    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()

    private var lblReachabilityDistanceFromTop: NSLayoutConstraint?
    private var lblReachabilityHeight: CGFloat = 25
    private var margin: CGFloat = 20
    private var stats: Stats?

    open override func loadView() {
        super.loadView()
        doViewLifeCycle()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.executeWithDelay(delay: 0.1) { [weak self] in
            guard let self = self else { return }
            self.firstAppearance = false
            if self.stats == nil {
                self.stats = Stats(frame: CGRect(x: 20, y: 40, width: 100.0, height: 60.0))
                self.view.addSubview(self.stats!)
            }
        }
    }
    
    open func displayMessage(_ message: String, type: AlertType) {
        var style = ToastStyle()
        style.cornerRadius = 5
        style.displayShadow = true
        style.messageFont = UIFont.App.regular(size: .regularBig)
        switch type {
        case .success: style.backgroundColor = UIColor.App.success.withAlphaComponent(FadeType.superLight.rawValue)
        case .warning: style.backgroundColor = UIColor.App.warning.withAlphaComponent(FadeType.superLight.rawValue)
        case .error: style.backgroundColor = UIColor.App.error.withAlphaComponent(FadeType.superLight.rawValue)
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

    // What should this function be used for? Add stuff to the view zone....
    // ...
    // addSubview(scrollView)
    // scrollView.addSubview(stackViewVLevel1)
    // ...
    //
    open func prepareLayoutCreateHierarchy() {
        AppLogger.warning(DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Setup layout rules zone....
    // ...
    // someView.autoLayout.widthToSuperview()
    // someView.autoLayout.bottomToSuperview()
    // ...
    //
    open func prepareLayoutBySettingAutoLayoutsRules() {
        AppLogger.warning(DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Extra stuff zone (not included in [prepareLayoutCreateHierarchy]
    // and [prepareLayoutBySettingAutoLayoutsRules]
    // ...
    // table.separatorColor = .clear
    // table.rx.setDelegate(self).disposed(by: disposeBag)
    // label.textAlignment = .center
    // ...
    open func prepareLayoutByFinishingPrepareLayout() {
        AppLogger.warning(DevTools.Strings.overrideMe.rawValue)
    }

    open func setupViewUIRx() {
        AppLogger.warning(DevTools.Strings.overrideMe.rawValue)
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

    private func label(baseView: UIView? = nil, title: String="", style: UILabel.LayoutStyle) -> UILabel {
        let some = UILabel()
        some.textAnimated = title
        some.numberOfLines = 0
        some.layoutStyle = style
        baseView?.addSubview(some)
        return some
    }
}
/*
//
// MARK: - Keyboard
//

extension BaseViewControllerMVP {
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) { }
    @objc private func keyboardDidShowNotification(_ notification: Notification) { keyboardIsVisible=true; self.keyboardDidShow() }
    @objc private func keyboardDidHideNotification(_ notification: Notification) { keyboardIsVisible=false; keyboardHeigth=0; self.keyboardDidHide() }
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    self.keyboardHeigth = contentInsets.bottom
                })
            }
        }
    }
}
*/
