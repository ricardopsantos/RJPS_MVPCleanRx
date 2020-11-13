//
//  Created by Ricardo Santos on 06/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var floatValue: CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
}

func colorFromRGBString(_ rgb: String) -> UIColor {
    guard !rgb.isEmpty else { return .black }

    var color: UIColor = .black
    let rgbSafe = rgb.replacingOccurrences(of: ";", with: ",", options: .literal, range: nil)
    let splited = rgbSafe.components(separatedBy: ",")
    if splited.count>=3 {
        let red   = splited[0].floatValue
        let green = splited[1].floatValue
        let blue  = splited[2].floatValue
        if splited.count==4 {
            let alpha = splited[3].floatValue
            color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)

        } else {
            color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
        }
    } else {
        return colorFromHexString(rgb)
    }
    return color
}

func colorFromHexString(_ hexString: String, alpha: Float=1.0) -> UIColor {

    func colorComponentsFrom(_ string: String, start: Int, length: Int) -> Float {
        let subString = (string as NSString).substring(with: NSMakeRange(start, length))
        var hexValue: UInt32 = 0
        Scanner(string: subString).scanHexInt32(&hexValue)
        return Float(hexValue) / 255.0
    }

    let colorString = hexString.replacingOccurrences(of: "#", with: "", options: .literal, range: nil).uppercased()
    let red, blue, green: Float
    red   = colorComponentsFrom(colorString, start: 0, length: 2)
    green = colorComponentsFrom(colorString, start: 2, length: 2)
    blue  = colorComponentsFrom(colorString, start: 4, length: 2)
    return  UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
}
