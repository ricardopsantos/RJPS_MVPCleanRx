//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RJPSLib
import RxCocoa
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
        //AppLogger.log("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }

    // Keyboard related init
    var _keyboardHeigth: CGFloat = 0
    var _keyboardIsVisible = false
    // Keyboard related end

    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()

    private var _lblReachabilityDistanceFromTop: NSLayoutConstraint?
    private var _lblReachabilityHeight: CGFloat = 25
    private var _margin: CGFloat = 20

    private lazy var _lblReachability: UILabel = {
        let some             = label(baseView: self.view, style: .title)
        some.textColor       = UIColor.App.TopBar.titleColor
        some.textAlignment   = .center
        some.backgroundColor = UIColor.App.error
        some.alpha           = 0
        some.rjsALayouts.setMargin(0, on: .left)
        some.rjsALayouts.setMargin(0, on: .right)
        _lblReachabilityDistanceFromTop = some.rjsALayouts.setMargin(0, on: .top, method: .constraints)
        some.rjsALayouts.setHeight(_lblReachabilityHeight)
        return some
    }()

    open override func loadView() {
        super.loadView()
        doViewLifeCycle()
        setupKeyboard()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _lblReachability.lazyLoad()
        _lblReachability.superview?.bringSubviewToFront(_lblReachability)
    }
    
    open func displayMessage(_ message: String, type: AlertType) {
        DevTools.makeToast(message, isError: type == .error)
    }
    
    open func setNoConnectionViewVisibility(to: Bool, withMessage: String = Messages.noInternet.localised) {
        RJS_Utils.executeInMainTread { [weak self] in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            let value = !to
            let duration = 0.5
            self._lblReachability.text = withMessage
            self._lblReachability.fadeTo(value ? 0 : 0.95, duration: duration)
            self._lblReachability.rjsALayouts.updateConstraint(self._lblReachabilityDistanceFromTop!,
                                                               toValue: value ? -self._lblReachabilityHeight : self._margin,
                                                               duration: duration,
                                                               completion: { (_) in
                                                                
            })
        }
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
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Setup layout rules zone....
    // ...
    // someView.autoLayout.widthToSuperview()
    // someView.autoLayout.bottomToSuperview()
    // ...
    //
    open func prepareLayoutBySettingAutoLayoutsRules() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Extra stuff zone (not included in [prepareLayoutCreateHierarchy]
    // and [prepareLayoutBySettingAutoLayoutsRules]
    // ...
    // table.separatorColor = .clear
    // table.rx.setDelegate(self).disposed(by: disposeBag)
    // label.textAlignment = .center
    // ...
    open func prepareLayoutByFinishingPrepareLayout() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    open func setupViewUIRx() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
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
        some.text = title
        some.numberOfLines = 0
        some.layoutStyle = style
        baseView?.addSubview(some)
        return some
    }
}

//
// MARK: - Keyboard
//

extension BaseViewControllerMVP {
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) { }
    @objc private func keyboardDidShowNotification(_ notification: Notification) { _keyboardIsVisible=true; self.keyboardDidShow() }
    @objc private func keyboardDidHideNotification(_ notification: Notification) { _keyboardIsVisible=false; _keyboardHeigth=0; self.keyboardDidHide() }
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    self._keyboardHeigth = contentInsets.bottom
                })
            }
        }
    }
}
