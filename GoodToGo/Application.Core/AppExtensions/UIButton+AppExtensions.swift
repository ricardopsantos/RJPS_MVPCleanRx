//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    enum LayoutStyle {
        case notAplyed
        case regular
        case dismiss
        case alternative
    }
    
    var layoutStyle: UIButton.LayoutStyle {
        set { layoutWith(style: newValue) }
        get { return .notAplyed }
    }
    
    func setState(enabled:Bool) -> Void {
        self.isUserInteractionEnabled = enabled
        self.alpha = enabled ? 1.0 : 0.6
    }
}

//
// Private
//
extension UIButton {
    
    private func layoutWith(style:UIButton.LayoutStyle) -> Void {
        let regular = {
            self.titleLabel?.font = AppFonts.regular(size: .big)
            self.backgroundColor  = AppColors.btnBackgroundColor
            self.setTextColorForAllStates(AppColors.btnTextColor)
            self.setState(enabled: true)
            self.layer.cornerRadius = 10.0
            self.clipsToBounds      = true
        }
        let alternative = {
            self.titleLabel?.font = AppFonts.regular(size: .small)
            self.backgroundColor  = AppColors.btnBackgroundColor
            self.setTextColorForAllStates(AppColors.btnTextColor)
            self.setState(enabled: true)
            self.layer.cornerRadius = 10.0
            self.clipsToBounds      = true
        }
        let dismiss = {
            self.titleLabel?.font = AppFonts.regular(size: .regular)
            self.backgroundColor  = AppColors.btnBackgroundColor
            self.setTextColorForAllStates(AppColors.btnTextColor)
            self.setTitleForAllStates(AppMessages.dismiss)
            self.setState(enabled: true)
            self.layer.cornerRadius = 4.0
            self.clipsToBounds      = true
        }
        switch style {
        case .notAplyed   : let _ = 1
        case .regular     : regular()
        case .alternative : alternative()
        case .dismiss     : dismiss()
        }
    }
    
}
