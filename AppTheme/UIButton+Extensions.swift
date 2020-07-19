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

    // Cant be o Designables because the Designables allready import AppTheme
    static var defaultFont: UIFont { AppFonts.Styles.paragraphMedium.rawValue }

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
        case .secondaryDestructive : self.applyStyleSecondaryDestructive()
        case .inngage     : self.applyStyleInngage()
        case .accept      : self.applyStyleAccept()
        case .reject      : self.applyStyleReject()
        case .remind      : self.applyStyleRemind()
        }
    }
}

private extension UIButton {

    func applySharedProperties() {
        self.setState(enabled: true)
        self.addShadow(shadowType: .regular)
    }

    func applyStyleInngage() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = AppColors.UIButton.backgroundColorInnGage
        self.setTextColorForAllStates(AppColors.UIButton.textColorInnGage)
        self.layer.cornerRadius = 10.0
        self.clipsToBounds      = true
    }

    func applyStyleAccept() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = AppColors.accept
        self.setTextColorForAllStates(AppColors.UIButton.textColorDefault)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }

    func applyStyleReject() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = AppColors.reject
        self.setTextColorForAllStates(AppColors.UIButton.textColorDefault)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }

    func applyStyleRemind() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = AppColors.remind
        self.setTextColorForAllStates(AppColors.UIButton.textColorDefault)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }
    func applyStylePrimary() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = AppColors.UIButton.backgroundColorDefault
        self.setTextColorForAllStates(AppColors.UIButton.textColorDefault)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }

    func applyStyleSecondary() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = UIColor.white
        self.setTextColorForAllStates(AppColors.primary)
        self.layer.borderWidth  = 2
        self.layer.borderColor  = AppColors.primary.cgColor
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
    }

    func applyStyleSecondaryDestructive() {
        applySharedProperties()
        self.titleLabel?.font = UIButton.defaultFont
        self.backgroundColor  = UIColor.white
        self.setTextColorForAllStates(AppColors.error)
        self.layer.cornerRadius = AppConstants.buttonDefaultSize.height / 2
        self.clipsToBounds      = true
        self.layer.borderWidth  = 2
        self.layer.borderColor  = AppColors.error.cgColor
    }

}
