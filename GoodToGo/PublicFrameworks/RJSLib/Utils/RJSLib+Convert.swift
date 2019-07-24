//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLib {
    
    public struct Convert {
        
        public struct Base64 {
            
            static func isBase64(_ testString:String)->Bool {
                if let decodedData = Data(base64Encoded: testString, options:NSData.Base64DecodingOptions(rawValue: 0)) {
                    let result     = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue)
                    return result != nil
                }
                return false
            }
            
            static func toPlainString(_ base64Encoded:String)->String? {
                if let decodedData  = Data(base64Encoded: base64Encoded, options:NSData.Base64DecodingOptions(rawValue: 0)) {
                    if let result = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
                        return result as String
                    }
                }
                return nil
            }
            
            static func toB64String (_ anyObject:AnyObject) -> String {
                var base64Encoded = ""
                if let data = anyObject as? Data {
                    base64Encoded = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                }
                else if let string = anyObject as? String {
                    let data       = string.data(using: String.Encoding.utf8)
                    base64Encoded  = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                }
                else if let image = anyObject as? UIImage {
                    let data : Data = image.pngData()!
                    base64Encoded = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                }
                else {
                    RJSLib.Utils.ASSERT_TRUE(false, message: RJSLib.Constants.notPredicted)
                }
                return base64Encoded
            }
        }
        
        private static func removeInvalidChars(_ text: String) -> String {
            let okayChars : Set<Character> = Set("0123456789,.-".characters)
            var result = String(text.filter {okayChars.contains($0) })
            result     = result.replacingOccurrences(of: "\n", with: "")
            result     = result.replacingOccurrences(of: " ", with: "")
            return result
        }
        
        public static func toNSDate(_ dateToParse:AnyObject) -> Date {
            return Date.with(toString(dateToParse))!
        }
        
        public static func toString(_ object:AnyObject?)-> String {
            guard object != nil else { return "(nil)" }
            return "\(object!)"
        }
        
        public static func toCGFloat(_ string:AnyObject?)-> CGFloat {
            guard string != nil else { return 0.0 }
            if let n1 = NumberFormatter().number(from: removeInvalidChars(toString(string))) {
                return CGFloat(truncating: n1)
            }
            if let n2 = NumberFormatter().number(from: removeInvalidChars(toString(string).replace(".", with: ","))) {
                return CGFloat(truncating: n2)
            }
            RJSLib.Utils.ASSERT_TRUE(false, message: RJSLib.Constants.fail)
            return 0
        }
        
        public static func toBool(_ string:AnyObject?)-> Bool {
            guard string != nil else { return false }
            if let n1 = NumberFormatter().number(from: removeInvalidChars(toString(string))) {
                return Bool(truncating: n1)
            }
            if let n2 = NumberFormatter().number(from: removeInvalidChars(toString(string).replace(".", with: ","))) {
                return Bool(truncating: n2)
            }
            RJSLib.Logs.DLogWarning("Fail on converting [\(String(describing: string))]")
            return false
        }
        
        public static func toDouble(_ string:AnyObject?)-> Double {
            guard string != nil else { return 0.0 }
            if let n1 = NumberFormatter().number(from: removeInvalidChars(toString(string))) {
                return Double(truncating: n1)
            }
            if let n2 = NumberFormatter().number(from: removeInvalidChars(toString(string).replace(".", with: ","))) {
                return Double(truncating: n2)
            }
            RJSLib.Logs.DLogWarning("Fail on converting [\(String(describing: string))]")
            return 0
        }
        
        public static func toFloat(_ string:AnyObject?)-> Float {
            guard string != nil else {
                return 0.0
            }
            if let n1 = NumberFormatter().number(from: removeInvalidChars(toString(string)))  {
                return Float(truncating: n1)
            }
            if let n2 = NumberFormatter().number(from: removeInvalidChars(toString(string).replace(".", with: ","))) {
                return Float(truncating: n2)
            }
            RJSLib.Logs.DLogWarning("Fail on converting [\(String(describing: string))]")
            return 0
        }
        
        public static func toInt(_ string:AnyObject?)-> Int {
            guard string != nil else {
                return 0
            }
            if let n = NumberFormatter().number(from: removeInvalidChars(toString(string))) {
                return Int(truncating: n)
            }
            RJSLib.Logs.DLogWarning("Fail on converting [\(String(describing: string))]")
            return 0
        }
        
    }
}




