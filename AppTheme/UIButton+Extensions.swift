//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

import AppResources

public extension UIButton {
    public enum LayoutStyle {
        case notAplyed
        case regular
        case dismiss
        case alternative
    }
    
    public var layoutStyle: UIButton.LayoutStyle {
        set { layoutWith(style: newValue) }
        get { return .notAplyed }
    }
    
    public func setState(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
        self.alpha = enabled ? 1.0 : 0.6
    }
}

//
// Private
//
extension UIButton {
    
    private func layoutWith(style: UIButton.LayoutStyle) {
        let regular = {
            self.titleLabel?.font = UIFont.App.regular(size: .big)
            self.backgroundColor  = UIColor.App.btnBackgroundColor
            self.setTextColorForAllStates(UIColor.App.btnTextColor)
            self.setState(enabled: true)
            self.layer.cornerRadius = 10.0
            self.clipsToBounds      = true
        }
        let alternative = {
            self.titleLabel?.font = UIFont.App.regular(size: .small)
            self.backgroundColor  = UIColor.App.btnBackgroundColor
            self.setTextColorForAllStates(UIColor.App.btnTextColor)
            self.setState(enabled: true)
            self.layer.cornerRadius = 10.0
            self.clipsToBounds      = true
        }
        let dismiss = {
            self.titleLabel?.font = UIFont.App.regular(size: .regular)
            self.backgroundColor  = UIColor.App.btnBackgroundColor
            self.setTextColorForAllStates(UIColor.App.btnTextColor)
            self.setTitleForAllStates(AppResources.Resources.Messages.dismiss)
            self.setState(enabled: true)
            self.layer.cornerRadius = 4.0
            self.clipsToBounds      = true
        }
                
        switch style {
        case .notAplyed   : _ = 1
        case .regular     : regular()
        case .alternative : alternative()
        case .dismiss     : dismiss()
        }
    }
    
}