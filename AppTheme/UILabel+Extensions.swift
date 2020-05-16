//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
            self.textColor       = UIColor.App.TopBar.titleColor
            self.font            = UIFont.App.bold(size: .big)
        }
        let title = {
            self.textColor       = UIColor.App.lblTextColor
            self.font            = UIFont.App.bold(size: .regularBig)
        }
        let value = {
            self.textColor       = UIColor.App.lblTextColor.withAlphaComponent(FadeType.regular.rawValue)
            self.font            = UIFont.App.regular(size: .regular)
        }
        let error = {
            self.textColor       = UIColor.App.error
            self.font            = UIFont.App.regular(size: .regularBig)
        }

        #warning("this should be a component, not a style")
        let info = {
            self.backgroundColor = UIColor.App.primary.withAlphaComponent(FadeType.heavyRegular.rawValue)
            self.textColor       = UIColor.App.onPrimary
            self.font            = UIFont.App.regular(size: .regular)
            self.addShadow()
            self.addCorner(radius: 5)
        }
        switch style {
        case .notApplied : _ = 1
        case .navigationBarTitle : navigationBarTitle()
        case .title              : title()
        case .value              : value()
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
