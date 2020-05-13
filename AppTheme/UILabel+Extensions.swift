//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

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
        let title = {
            self.backgroundColor = .clear
            self.textColor       = UIColor.App.TopBar.titleColor
            self.font            = UIFont.App.bold(size: .big)
            self.numberOfLines  = 0
            self.addShadow()
        }
        let value = {
            self.backgroundColor = .clear
            self.textColor       = UIColor.App.lblTextColor.withAlphaComponent(0.8)
            self.font            = UIFont.App.regular(size: .small)
            self.numberOfLines  = 0
            self.addShadow()
        }
        switch style {
        case .notApplied : _ = 1
        case .title      : title()
        case .value      : value()
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
