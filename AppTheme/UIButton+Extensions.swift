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
        self.alpha = enabled ? 1.0 : 0.6
    }

    func apply(style: UIButton.LayoutStyle) {
        let regular = {
            self.titleLabel?.font = UIFont.App.bold(size: .regular)
            self.backgroundColor  = UIColor.App.btnBackgroundColor
            self.setTextColorForAllStates(UIColor.App.btnTextColor)
            self.setState(enabled: true)
            self.layer.cornerRadius = 10.0
            self.clipsToBounds      = true
            self.addShadow()
        }
        let alternative = {
            self.titleLabel?.font = UIFont.App.bold(size: .regularBig)
            self.backgroundColor  = UIColor.App.btnBackgroundColor
            self.setTextColorForAllStates(UIColor.App.btnTextColor)
            self.setState(enabled: true)
            self.layer.cornerRadius = 15.0
            self.clipsToBounds      = true
            self.addShadow(shadowType: .heavy)
        }
        let dismiss = {
            self.titleLabel?.font = UIFont.App.regular(size: .regular)
            self.backgroundColor  = UIColor.App.btnBackgroundColor
            self.setTextColorForAllStates(UIColor.App.btnTextColor)
            self.setTitleForAllStates(Messages.dismiss.localised)
            self.setState(enabled: true)
            self.layer.cornerRadius = 4.0
            self.clipsToBounds      = true
            self.addShadow()
        }

        switch style {
        case .notApplied  : _ = 1
        case .regular     : regular()
        case .alternative : alternative()
        case .dismiss     : dismiss()
        }
    }
}
