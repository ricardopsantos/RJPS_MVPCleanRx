//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    private func toDark() -> UIColor {
        guard GenericView.onDarkMode else {
            return self
        }
        let k: CGFloat = 1.2
        //let treshold: CGFloat = 0.5
        let r: CGFloat = CGFloat(self.cgColor.components![0]/k)
        let g: CGFloat = CGFloat(self.cgColor.components![1]/k)
        let b: CGFloat = CGFloat(self.cgColor.components![2]/k)
        //var mean = (r + g + b) / 3.0
        //guard mean > treshold else {
        //    return self
        //}
        var a: CGFloat = 3
        if cgColor.components!.count == 4 {
            a = CGFloat(cgColor.components![3])
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    struct App {
        private init() {}
        
        private static let _grey_1 = UIColor.colorFromRGBString("91,92,123")
        private static let _grey_2 = UIColor.colorFromRGBString("127,128,153")
        private static let _grey_3 = UIColor.colorFromRGBString("151,155,176")
        private static let _grey_5 = UIColor.colorFromRGBString("221,225,233")
        private static let _grey_6 = UIColor.colorFromRGBString("235,238,243")
        private static let _grey_7 = UIColor.colorFromRGBString("244,246,250")
        
        private static let _red1   = UIColor.colorFromRGBString("255,100,100")
        private static let _blue1  = UIColor.colorFromRGBString("10,173,175")
        private static let _blue2  = UIColor.colorFromRGBString("148,208,187")
            
        struct TopBar {
            private init() {}
            static var background: UIColor { return _blue1.toDark() }
            static var titleColor: UIColor { return _grey_7.toDark() }
        }
        static var appDefaultBackgroundColor: UIColor { return _grey_7.toDark() }
        static var btnBackgroundColor: UIColor { return _grey_6.toDark() }
        static var lblBackgroundColor: UIColor { return _grey_6.toDark() }
        static var btnTextColor: UIColor { return _grey_1.toDark() }
        static var lblTextColor: UIColor { return _grey_1.toDark() }
        
        static var error: UIColor { return _red1.toDark() }
        static var sucess: UIColor { return _blue2.toDark() }
        static var warning: UIColor { return UIColor(red: 242, green: 168, blue: 62).toDark() }
    }
}
