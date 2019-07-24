//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//MARK: Vars

public extension String {
    
    public var length: Int {
        #if swift(>=3.2)
        return self.count
        #else
        return self.characters.count
        #endif
    }
    
    public var first     : String { return self[0] }
    public var last      : String { if(self.count == 0) { return "" } else { return self[self.count-1] } }
    public var trim      : String { return self.trimmingCharacters(in: .whitespacesAndNewlines) }
    public var reversed  : String { var acc = ""; for char in self { acc = "\(char)\(acc)" }; return acc }
    public var urlEncoded: String { return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! }
    
    subscript (i: Int) -> Character { return self[self.characters.index(self.startIndex, offsetBy: i)] }
    subscript (i: Int) -> String { return String(self[i] as Character) }
    
    func stringByReplacingOccurrencesOfString(old:String, new:String) -> String {
        return (self as NSString).replacingOccurrences(of: old, with: new)
    }

    public func splitBy(_ char:String)->[String] {
        guard !char.isEmpty else { return [] }
        if(char.count > 1) {
            RJSLib.Logs.DLogWarning("Demiliter [\(char)] should have len=1.")
        }
        return self.components(separatedBy: char.first)
    }
    
    #warning("fix")
    /*
    static func criptoDefaultPassword() -> String { return "#jJuxWDjU8y1V(-xK3dY1r8dia@muyQ!" }
    public func decrypt(with password:String=String.criptoDefaultPassword()) -> String? {
        RJSLib.Utils.ASSERT_TRUE(password.count == 32, message: "Invalid password")
        return AES256CBC.decryptString(self, password: password)
    }
    
    public func encrypt(with password:String=String.criptoDefaultPassword()) -> String? {
        RJSLib.Utils.ASSERT_TRUE(password.count == 32, message: "Invalid password")
        return AES256CBC.encryptString(self, password: password)
    }
    */
    
    //Found at https://medium.com/@darthpelo/email-validation-in-swift-3-0-acfebe4d879a
    public var isValidEmail : Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public func contains(subString:String, ignoreCase:Bool=true) -> Bool {
        if(ignoreCase) { return self.lowercased().range(of:subString.lowercased()) != nil }
        else { return self.range(of:subString) != nil }
    }
    
    public func replace(_ some:String, with:String) -> String {
        guard !some.isEmpty else { return self }
        return self.replacingOccurrences(of: some, with: with)
    }
    
    func htmlAttributedString(with fontName: String, fontSize: Int, colorHex: String) -> NSAttributedString? {
        do {
            let cssPrefix = "<style>* { font-family: \(fontName); color: #\(colorHex); font-size: \(fontSize); }</style>"
            let html = cssPrefix + self
            guard let data = html.data(using: String.Encoding.utf8) else {  return nil }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
        
        let test = {
            let html = "<strong>Dear Friend</strong> I hope this <i>tip</i> will be useful for <b>you</b>."
            let attributedString = html.htmlAttributedString(with: "Futura", fontSize: 14, colorHex: "ff0000")

        }
        test()
    }
    
}
