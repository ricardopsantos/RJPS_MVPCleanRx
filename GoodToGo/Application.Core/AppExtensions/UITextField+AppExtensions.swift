//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
extension UITextField {
    
    @IBInspectable var leftPaddingWidth: CGFloat {
        get { return leftView!.frame.size.width }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView     = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rigthPaddingWidth: CGFloat {
        get { return rightView!.frame.size.width }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}


