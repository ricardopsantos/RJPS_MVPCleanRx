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

//
import DevTools
import Extensions
import AppTheme
import AppConstants
import AppResources
import PointFreeFunctions
import Domain

//
// MARK: - Keyboard
//

extension BaseViewControllerMVP {
    private struct Keyboard {
        private init() {}
        static var keyboardHeight: CGFloat = 0
    }
}

extension BaseViewControllerMVP {

    var keyboardHeight: CGFloat {
        if keyboardIsVisible {
            let autoCorrectBarSize: CGFloat = 44; return BaseViewControllerMVP.Keyboard.keyboardHeight - autoCorrectBarSize
        } else {
            return 0
        }
    }

    func setupKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) { }
    @objc private func keyboardDidShowNotification(_ notification: Notification) { keyboardIsVisible=true; self.keyboardDidShow() }
    @objc private func keyboardDidHideNotification(_ notification: Notification) { keyboardIsVisible=false; BaseViewControllerMVP.Keyboard.keyboardHeight=0; self.keyboardDidHide() }
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    BaseViewControllerMVP.Keyboard.keyboardHeight = contentInsets.bottom
                })
            }
        }
    }
}
