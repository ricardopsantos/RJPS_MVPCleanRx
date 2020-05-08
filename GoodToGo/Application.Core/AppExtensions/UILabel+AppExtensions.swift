//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension UILabel {
    
    enum LayoutStyle {
        case notAplyed /// not Applied
        case title
        case value
    }
    var layoutStyle: UILabel.LayoutStyle {
        set { layoutWith(style: newValue) }
        get { return .notAplyed }
    }
    var textAnimated: String? {
        set { fadeTransition(); self.text = newValue ?? "" }
        get { return self.text }
    }
}

//
// Private
//

extension UILabel {
    
    private func layoutWith(style:UILabel.LayoutStyle) -> Void {
        let title = {
            self.backgroundColor = .clear
            self.textColor       = AppColors.TopBar.titleColor
            self.font            = AppFonts.bold(size: .big)
            self.numberOfLines  = 0
        }
        let value = {
            self.backgroundColor = .clear
            self.textColor       = AppColors.lblTextColor
            self.font            = AppFonts.regular(size: .small)
            self.numberOfLines  = 0
        }
        switch style {
        case .notAplyed : _ = 1
        case .title     : title()
        case .value     : value()
        }
    }
    
    private func fadeTransition(_ duration: CFTimeInterval=0.5) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type           = .fade
        animation.duration       = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
}
