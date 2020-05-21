//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import AppResources
import AppConstants
import DevTools
import PointFreeFunctions
import Extensions

public extension UIButton {

    var layoutStyle: UIButton.LayoutStyle {
        set { apply(style: newValue) }
        get { return .notApplied }
    }
    
    func setState(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
        self.alpha = enabled ? 1.0 : FadeType.disabledUIElementDefaultValue.rawValue
    }

    func apply(style: UIButton.LayoutStyle) {
        switch style {
        case .notApplied  : _ = 1
        case .primary     : self.applyStylePrimary()
        case .secondary   : self.applyStyleSecondary()
        //case .dismiss     : self.applyStylePrimary()
        //case .alternative : self.applyStylePrimary()
        case .destructive : self.applyStyleDestructive()
        case .inngage     : self.applyStyleInngage()
        }
    }
}

private extension UIButton {

    var defaultFont: UIFont { UIFont.App.bold(size: .regular) }

    func applySharedProperties() {
        self.setState(enabled: true)
        self.addShadow(shadowType: .regular)
    }

    func applyStyleInngage() {
        applySharedProperties()
        self.titleLabel?.font = defaultFont
        self.backgroundColor  = UIColor.App.UIButton.backgroundColorInnGage
        self.setTextColorForAllStates(UIColor.App.UIButton.textColorInnGage)
        self.layer.cornerRadius = 10.0
        self.clipsToBounds      = true
    }

    func applyStylePrimary() {
        applySharedProperties()
        self.titleLabel?.font = defaultFont
        self.backgroundColor  = UIColor.App.UIButton.backgroundColorDefault
        self.setTextColorForAllStates(UIColor.App.UIButton.textColorDefault)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }

    func applyStyleSecondary() {
        applySharedProperties()
        self.titleLabel?.font = defaultFont
        self.backgroundColor  = UIColor.white //UIColor.App.onPrimary
        self.setTextColorForAllStates(UIColor.App.primary)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.App.primary.cgColor
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }

    func applyStyleDestructive() {
        applySharedProperties()
        self.titleLabel?.font = defaultFont
        self.backgroundColor  = UIColor.white //UIColor.App.onPrimary
        self.setTextColorForAllStates(UIColor.App.primary)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.App.error.cgColor
    }

    func applyStyleDismiss() {
        applySharedProperties()
        self.titleLabel?.font = defaultFont
        self.backgroundColor  = UIColor.App.UIButton.backgroundColorDefault
        self.setTextColorForAllStates(UIColor.App.UIButton.textColorDefault)
        self.setTitleForAllStates(Messages.dismiss.localised)
        self.layer.cornerRadius = 4.0
        self.clipsToBounds      = true
    }
}
