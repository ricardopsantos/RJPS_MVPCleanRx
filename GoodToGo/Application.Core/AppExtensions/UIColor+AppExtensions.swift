//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    struct App {
        private init() {}
        
        private static let _grey_1   = UIColor.colorFromRGBString("91,92,123")
        private static let _grey_2   = UIColor.colorFromRGBString("127,128,153")
        private static let _grey_3   = UIColor.colorFromRGBString("151,155,176")
        private static let _grey_5   = UIColor.colorFromRGBString("221,225,233")
        private static let _grey_6   = UIColor.colorFromRGBString("235,238,243")
        private static let _grey_7   = UIColor.colorFromRGBString("244,246,250")
        
        private static let _red1   = UIColor.colorFromRGBString("255,100,100")
        private static let _blue1  = UIColor.colorFromRGBString("10,173,175")
        private static let _blue2  = UIColor.colorFromRGBString("148,208,187")
        
        struct TopBar {
            private init() {}
            static let background : UIColor = _blue1
            static let titleColor : UIColor = _grey_7
        }
        static let appDefaultBackgroundColor : UIColor = _grey_7
        static let btnBackgroundColor        : UIColor = _grey_6
        static let lblBackgroundColor        : UIColor = _grey_6
        static let btnTextColor              : UIColor = _grey_1
        static let lblTextColor              : UIColor = _grey_1
        
        static let error   : UIColor = _red1
        static let sucess  : UIColor = _blue2
        static let warning : UIColor = UIColor(red:242, green:168, blue:62)


        
    }
}
