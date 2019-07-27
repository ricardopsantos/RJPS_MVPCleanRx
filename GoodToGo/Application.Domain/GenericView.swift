//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RJPSLib
import RxCocoa

class GenericView: UIViewController {
    deinit {
        AppLogs.DLog("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    
    var reachabilityService: ReachabilityService! = try! DefaultReachabilityService() // try! is only for simplicity sake
    var disposeBag : DisposeBag = DisposeBag()
    private var _keyboardIsVisible = false
    private var _keyboardHeigth : CGFloat = 0
    var keyboardHeigth : CGFloat {
        if(_keyboardIsVisible) { let autoCorrectBarSize : CGFloat = 44; return _keyboardHeigth - autoCorrectBarSize }
        else { return 0 }
    }
    
    private var _lblMessageDistanceFromTop      : NSLayoutConstraint?
    private var _lblReachabilityDistanceFromTop : NSLayoutConstraint?
    private var _lblReachabilityHeight : CGFloat = 25
    private var _lblMessageHeight      : CGFloat = V.TopBar.defaultHeight
    private var _margin                : CGFloat = 20
    private var _lblMessageTimmer : Timer?

    private lazy var _lblReachability: UILabel = {
        let some             = AppFactory.UIKit.label(baseView: self.view, style: .title)
        some.textColor       = AppColors.TopBar.titleColor
        some.textAlignment   = .center
        some.backgroundColor = AppColors.error
        some.alpha           = 0
        some.rjsALayouts.setMargin(0, on: .left)
        some.rjsALayouts.setMargin(0, on: .right)
        _lblReachabilityDistanceFromTop = some.rjsALayouts.setMargin(0, on: .top, method: .constraints)
        some.rjsALayouts.setHeight(_lblReachabilityHeight)
        return some
    }()
    
    private lazy var _lblMessage: UILabel = {
        let some           = AppFactory.UIKit.label(baseView: self.view, style: .title)
        some.textColor     = AppColors.TopBar.titleColor
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
        tapGesture.rx.event.bind(onNext: { [weak self]  recognizer in
            guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
            strongSelf.setTopMessageVisibityTo(state: false, message: "", type: .sucess)
        }).disposed(by: disposeBag)
        return some
    }()
    
    override func loadView() {
        super.loadView()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidShowNotification(_:)),  name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidHideNotification(_:)),  name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _lblReachability.lazyLoad()
        _lblReachability.superview?.bringSubviewToFront(_lblReachability)
        _lblMessage.lazyLoad()
        _lblMessage.superview?.bringSubviewToFront(_lblReachability)
    }
    
    func displayMessage(_ message: String, type: Enuns.AlertType, asAlert:Bool=false) {
        if(asAlert) {
            (self as UIViewController).rjs.showAlert(title: "\(type)".uppercased(), message: message)
        }
        else {
            setTopMessageVisibityTo(state: true, message: message, type: type)
        }
    }
    
    func setNoConnectionViewVisibity(to: Bool, withMessage: String = AppMessages.noInternet) {
        RJS_Utils.executeInMainTread { [weak self] in
            guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
            let value = !to
            let duration = 0.5
            strongSelf._lblReachability.text = withMessage
            strongSelf._lblReachability.fadeTo(value ? 0 : 0.95, duration:duration)
            strongSelf._lblReachability.rjsALayouts.updateConstraint(strongSelf._lblReachabilityDistanceFromTop!,
                                                               toValue: value ? -strongSelf._lblReachabilityHeight : strongSelf._margin,
                                                               duration:duration,
                                                               completion: { (_) in
                                                                
            })
        }
    }
    
    func setActivityState(_ state:Bool) {
        if(state) { self.view.rjs.startActivityIndicator() }
        else { self.view.rjs.stopActivityIndicator() }
    }
    
    func prepareLayout()    -> Void { AppLogs.DLog(code: .notImplemented) }
    func keyboardDidShow() { }
    func keyboardDidHide() { }
    func dismissKeyboard()  -> Void { }
}

//
//MARK: Private stuff
//

extension GenericView {
    
    @objc func hideTopMessage() {
        setTopMessageVisibityTo(state: false, message: "", type: .sucess)
    }
    
    private func setTopMessageVisibityTo(state:Bool, message: String, type: Enuns.AlertType) {
        if(state) {
            _lblMessageTimmer?.invalidate()
            _lblMessageTimmer = nil
        }
        RJS_Utils.executeInMainTread { [weak self] in
            guard let strongSelf1 = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
            let value = !state
            let duration = 0.5
            if(state) {
                strongSelf1._lblMessage.text = message
                switch type {
                case .sucess : strongSelf1._lblMessage.backgroundColor = AppColors.sucess
                case .warning: strongSelf1._lblMessage.backgroundColor = AppColors.warning
                case .error  : strongSelf1._lblMessage.backgroundColor = AppColors.error
                }
            }
            strongSelf1._lblMessage.fadeTo(value ? 0 : 0.95, duration:duration)
            strongSelf1._lblMessage.rjsALayouts.updateConstraint(strongSelf1._lblMessageDistanceFromTop!,
                                                                     toValue: value ? -strongSelf1._lblMessageHeight : strongSelf1._margin,
                                                                     duration:duration,
                                                                     completion: { (_) in
            })
            
            strongSelf1._lblMessageTimmer = Timer.scheduledTimer(timeInterval: 3, target: strongSelf1, selector: #selector(strongSelf1.hideTopMessage), userInfo: nil, repeats: false)

        }
    }
}

//
//MARK: Keyboard
//

extension GenericView {
    
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
