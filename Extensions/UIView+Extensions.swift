//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib

public extension UIView {
    func lazyLoad() { /* Lazy loading aux */ }
    func fadeTo(_ value: CGFloat, duration: Double=RJS_Constants.defaultAnimationsTime) {
        RJS_Utils.executeInMainTread { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.alpha = value
            }
        }

    }
}
