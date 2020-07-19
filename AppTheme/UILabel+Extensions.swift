//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import AppConstants

public extension UILabel {
    
    var layoutStyle: UILabel.LayoutStyle {
        set { apply(style: newValue) }
        get { return .notApplied }
    }
    var textAnimated: String? {
        set { fadeTransition(); self.text = newValue ?? "" }
        get { return self.text }
    }

    func apply(style: UILabel.LayoutStyle) {
        let navigationBarTitle = {
            self.textColor       = AppColors.TopBar.titleColor
            self.font            = AppFonts.Styles.headingMedium.rawValue
        }
        let title = {
            self.textColor       = AppColors.UILabel.lblTextColor
            self.font            = AppFonts.Styles.paragraphBold.rawValue
        }
        let value = {
            self.textColor       = AppColors.UILabel.lblTextColor.withAlphaComponent(FadeType.superLight.rawValue)
            self.font            = AppFonts.Styles.paragraphSmall.rawValue
        }
        let text = {
            self.textColor       = AppColors.UILabel.lblTextColor
            self.font            = AppFonts.Styles.caption.rawValue
        }
        let error = {
            self.textColor       = AppColors.error
            self.font            = AppFonts.Styles.captionSmall.rawValue
        }

        #warning("this should be a component, not a style")
        let info = {
            self.backgroundColor = AppColors.primary.withAlphaComponent(FadeType.regular.rawValue)
            self.textColor       = AppColors.onPrimary
            self.font            = AppFonts.Styles.captionLarge.rawValue
            self.addShadow()
            self.addCorner(radius: 5)
        }
        switch style {
        case .notApplied         : _ = 1
        case .navigationBarTitle : navigationBarTitle()
        case .title              : title()
        case .value              : value()
        case .text               : text()
        case .error              : error()
        case .info               : info()
        }
    }
}

//
// Private
//

extension UILabel {
    
    private func fadeTransition(_ duration: CFTimeInterval=0.5) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type           = .fade
        animation.duration       = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
}
