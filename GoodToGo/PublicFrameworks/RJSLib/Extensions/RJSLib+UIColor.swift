//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//MARK: Vars

extension RJSLibExtension where Target == UIColor {
        
    static func colorComponentsFrom(_ string: NSString, start: Int, length: Int) -> Float {
        NSMakeRange(start, length)
        let subString = string.substring(with: NSMakeRange(start, length))
        var hexValue: UInt32 = 0
        Scanner(string: subString).scanHexInt32(&hexValue)
        return Float(hexValue) / 255.0
    }
    
    static func colorFromHexString(_ hexString: String, alpha:Float=1.0) -> UIColor {
        if let cachedValue = RJSLib.Storages.Cache.get(key: hexString) as? UIColor { return cachedValue }
        let colorString = hexString.stringByReplacingOccurrencesOfString(old: "#", new: "").uppercased()
        let red, blue, green: Float
        red   = colorComponentsFrom(colorString as NSString, start: 0, length: 2)
        green = colorComponentsFrom(colorString as NSString, start: 2, length: 2)
        blue  = colorComponentsFrom(colorString as NSString, start: 4, length: 2)
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        RJSLib.Storages.Cache.add(color: color, withKey: hexString)
        return color
    }
    
    static func colorFromRGBString(_ rgb: String) -> UIColor {
        guard !rgb.isEmpty else { return .black }
        
        if let cachedValue = RJSLib.Storages.Cache.get(key: rgb) as? UIColor { return cachedValue }
        
        var color : UIColor = .black
        let rgb_safe = rgb.trim.replace(";", with: ",")
        let splited = rgb_safe.splitBy(",")
        if(splited.count>=3) {
            let red   = RJSLib.Convert.toCGFloat(splited[0] as AnyObject)
            let green = RJSLib.Convert.toCGFloat(splited[1] as AnyObject)
            let blue  = RJSLib.Convert.toCGFloat(splited[2] as AnyObject)
            if(splited.count==4) {
                let alpha = RJSLib.Convert.toCGFloat(splited[3] as AnyObject)
                color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
                
            }
            else {
                color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
            }
        }
        else {
            return colorFromHexString(rgb)
        }
        RJSLib.Storages.Cache.add(color: color, withKey: rgb)
        return color
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

