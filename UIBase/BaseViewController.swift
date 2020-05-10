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
import AppDomain

open class BaseViewController: UIViewController, BaseViewProtocol {

    deinit {
        AppLogger.log("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    
    var reachabilityService: ReachabilityService! = try! DefaultReachabilityService() // try! is only for simplicity sake
    public var disposeBag: DisposeBag = DisposeBag()
    private var _keyboardIsVisible = false
    private var _keyboardHeigth: CGFloat = 0
    var keyboardHeigth: CGFloat {
        if _keyboardIsVisible {
            let autoCorrectBarSize: CGFloat = 44; return _keyboardHeigth - autoCorrectBarSize
        } else {
            return 0
        }
    }
    
    static var onDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return BaseViewController().traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
    
    private var _lblMessageDistanceFromTop: NSLayoutConstraint?
    private var _lblReachabilityDistanceFromTop: NSLayoutConstraint?
    private var _lblReachabilityHeight: CGFloat = 25
    private var _lblMessageHeight: CGFloat = 60// TopBar.defaultHeight
    private var _margin: CGFloat = 20
    private var _lblMessageTimmer: Timer?

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
    
    private lazy var _lblMessage: UILabel = {
        let some           = label(baseView: self.view, style: .title)
        some.textColor     = UIColor.App.TopBar.titleColor
        some.textAlignment = .center
        some.alpha         = 0
        some.numberOfLines = 0
        some.rjsALayouts.setMargin(0, on: .left)
        some.rjsALayouts.setMargin(0, on: .right)
        _lblMessageDistanceFromTop = some.rjsALayouts.setMargin(0, on: .top, method: .constraints)
        some.rjsALayouts.setHeight(_lblMessageHeight)
        some.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        some.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            self.setTopMessageVisibilityTo(state: false, message: "", type: .success)
        }).disposed(by: disposeBag)
        return some
    }()
    
    open override func loadView() {
        super.loadView()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        doViewLifeCycle()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _lblReachability.lazyLoad()
        _lblReachability.superview?.bringSubviewToFront(_lblReachability)
        _lblMessage.lazyLoad()
        _lblMessage.superview?.bringSubviewToFront(_lblReachability)
    }
    
    open func displayMessage(_ message: String, type: AlertType) {
        //let asAlert = false
        //if asAlert {
        //    (self as UIViewController).rjs.showAlert(title: "\(type)".uppercased(), message: message)
        //} else {
            setTopMessageVisibilityTo(state: true, message: message, type: type)
        //}
    }
    
    open func setNoConnectionViewVisibility(to: Bool, withMessage: String = AppMessages.noInternet.localised) {
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
    
    //open func prepareLayout() { AppLogger.log(appCode: .notImplemented) }
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
        assert(false, message: "Override me!")
    }

    // What should this function be used for? Setup layout rules zone....
    // ...
    // someView.autoLayout.widthToSuperview()
    // someView.autoLayout.bottomToSuperview()
    // ...
    //
    open func prepareLayoutBySettingAutoLayoutsRules() {
        assert(false, message: "Override me!")
    }

    // What should this function be used for? Extra stuff zone (not included in [prepareLayoutCreateHierarchy]
    // and [prepareLayoutBySettingAutoLayoutsRules]
    // ...
    // table.separatorColor = .clear
    // table.rx.setDelegate(self).disposed(by: disposeBag)
    // label.textAlignment = .center
    // ...
    open func prepareLayoutByFinishingPrepareLayout() {
        assert(false, message: "Override me!")
    }

    open func setupViewUIRx() {
        assert(false, message: "Override me!")
    }

}

//
// MARK: - loadingViewable
//

public extension BaseViewController {
    func setActivityState(_ state: Bool) {
        if state {
            self.view.rjs.startActivityIndicator()
        } else { self.view.rjs.stopActivityIndicator() }
    }
}

//
// MARK: - Private stuff
//

extension BaseViewController {

    private func label(baseView: UIView? = nil, title: String="", style: UILabel.LayoutStyle, tag: Int=0) -> UILabel {
        let some = UILabel()
        some.text = title
        some.numberOfLines = 0
        some.tag = tag
        some.layoutStyle = style
        baseView?.addSubview(some)
        return some
    }

    @objc func hideTopMessage() {
        setTopMessageVisibilityTo(state: false, message: "", type: .success)
    }
    
    private func setTopMessageVisibilityTo(state: Bool, message: String, type: AlertType) {
        if state {
            _lblMessageTimmer?.invalidate()
            _lblMessageTimmer = nil
        }
        RJS_Utils.executeInMainTread { [weak self] in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            let value = !state
            let duration = 0.5
            if state {
                self._lblMessage.text = message
                switch type {
                case .success : self._lblMessage.backgroundColor = UIColor.App.success
                case .warning: self._lblMessage.backgroundColor = UIColor.App.warning
                case .error  : self._lblMessage.backgroundColor = UIColor.App.error
                }
            }
            self._lblMessage.fadeTo(value ? 0 : 0.95, duration: duration)
            self._lblMessage.rjsALayouts.updateConstraint(self._lblMessageDistanceFromTop!,
                                                                     toValue: value ? -self._lblMessageHeight : self._margin,
                                                                     duration: duration,
                                                                     completion: { (_) in
            })
            
            self._lblMessageTimmer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.hideTopMessage), userInfo: nil, repeats: false)

        }
    }
}

//
// MARK: - Keyboard
//

extension BaseViewController {
    
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
