//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Vars
    
public extension UIColor {
    
    static func colorComponentsFrom(_ string: String, start: Int, length: Int) -> Float {
        let subString = (string as NSString).substring(with: NSMakeRange(start, length))
        var hexValue: UInt32 = 0
        Scanner(string: subString).scanHexInt32(&hexValue)
        return Float(hexValue) / 255.0
    }
    
    static func colorFromHexString(_ hexString: String, alpha: Float=1.0) -> UIColor {
        if let cachedValue = RJS_CacheLive.get(key: hexString) as? UIColor { return cachedValue }
        let colorString = hexString.stringByReplacingOccurrencesOfString(old: "#", new: "").uppercased()
        let red, blue, green: Float
        red   = colorComponentsFrom(colorString, start: 0, length: 2)
        green = colorComponentsFrom(colorString, start: 2, length: 2)
        blue  = colorComponentsFrom(colorString, start: 4, length: 2)
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        RJS_CacheLive.add(object: color, withKey: hexString)
        return color
    }
    
    static func colorFromRGBString(_ rgb: String) -> UIColor {
        guard !rgb.isEmpty else { return .black }
        
        if let cachedValue = RJS_CacheLive.get(key: rgb) as? UIColor { return cachedValue }
        
        var color: UIColor = .black
        let rgbSafe = rgb.trim.replace(";", with: ",")
        let splited = rgbSafe.splitBy(",")
        if splited.count>=3 {
            let red   = RJSLib.Convert.toCGFloat(splited[0])
            let green = RJSLib.Convert.toCGFloat(splited[1])
            let blue  = RJSLib.Convert.toCGFloat(splited[2])
            if splited.count==4 {
                let alpha = RJSLib.Convert.toCGFloat(splited[3])
                color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
                
            } else {
                color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
            }
        } else {
            return colorFromHexString(rgb)
        }
        RJS_CacheLive.add(object: color, withKey: rgb)
        return color
    }
}

extension UIColor {
    
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
