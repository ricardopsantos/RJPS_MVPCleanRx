//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

// MARK: - SubScript

public extension String {

    subscript (i: Int) -> String { return self[i ..< i + 1] }

    func substring(fromIndex: Int) -> String { return self[min(fromIndex, length) ..< length] }

    func substring(toIndex: Int) -> String { return self[0 ..< max(0, toIndex)] }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

}

// MARK: - Transformations

public extension String {
    var encodedUrl: String? { return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) }
    var decodedUrl: String? { return self.removingPercentEncoding }
    var reversed: String { var acc = ""; for char in self { acc = "\(char)\(acc)" }; return acc }
    var base64Encoded: String { return RJS_Convert.Base64.toB64String(self as AnyObject) }
    var base64Decoded: String? { return RJS_Convert.Base64.toPlainString(self) }
    var aesDecrypted: String { return self.aesDecrypt() }
    var aesEncrypted: String { return self.aesEncrypt() }
}

// MARK: - Hashing

public extension String {
    var deterministicHashValue: Int {
         return zip(utf8.map(numericCast), Swift.sequence(first: 1, next: { $0 &* 589836 })).map(&*).reduce(0, &+)
     }

     var sha1: String {
         let data = Data(self.utf8)
         var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
         data.withUnsafeBytes {
             _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
         }
         let hexBytes = digest.map { String(format: "%02hhx", $0) }
         return hexBytes.joined()
     }
}

// MARK: - Tests

public extension String {
    //Found at https://medium.com/@darthpelo/email-validation-in-swift-3-0-acfebe4d879a
    var isValidEmail: Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

// MARK: - Utils

public extension String {

    var length: Int { return self.count }
    var first: String { return String(self.prefix(1)) }
    var last: String { if self.count == 0 { return "" } else { return String(self.suffix(1))} }
    var trim: String { return self.trimmingCharacters(in: .whitespacesAndNewlines) }
    var trimmedAndSingleSpaced: String { return replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trim }

    var decimalValue: Decimal? {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let groupingSeparator = Locale.current.groupingSeparator ?? ","
        let regex: NSRegularExpression! = try? NSRegularExpression(pattern: "[^0-9\(decimalSeparator)]", options: .caseInsensitive)
        var formatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.decimalSeparator = decimalSeparator
            formatter.groupingSeparator = groupingSeparator
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }

        let regexedString = regex.stringByReplacingMatches(in: self,
                                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                           range: NSRange(location: 0, length: self.count),
                                                           withTemplate: "")

        return formatter.number(from: regexedString)?.decimalValue
    }
    
    func aesEncrypt(password: String = "3ec7b94c83124d188ff8fe75e402f1ab") -> String { return AES256CBC.encryptString(self, password: password) ?? "" }
    func aesDecrypt(password: String = "3ec7b94c83124d188ff8fe75e402f1ab") -> String { return AES256CBC.decryptString(self, password: password) ?? "" }

    func split(by: String) -> [String] {
        guard !by.isEmpty else { return [] }
        return self.components(separatedBy: by.first)
    }

    func contains(subString: String, ignoreCase: Bool=true) -> Bool {
        if ignoreCase {
            return self.lowercased().range(of: subString.lowercased()) != nil
        } else {
            return self.range(of: subString) != nil
        }
    }
    
    func replace(_ some: String, with: String) -> String {
        guard !some.isEmpty else { return self }
        return self.replacingOccurrences(of: some, with: with)
    }
    
    func htmlAttributedString(fontName: String, fontSize: Int, colorHex: String) -> NSAttributedString? {
        do {
            let cssPrefix = "<style>* { font-family: \(fontName); color: #\(colorHex); font-size: \(fontSize); }</style>"
            let html = cssPrefix + self
            guard let data = html.data(using: String.Encoding.utf8) else {  return nil }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            RJS_Logs.error("\(error)")
            return nil
        }
        /*
         let test = {
         let html = "<strong>Dear Friend</strong> I hope this <i>tip</i> will be useful for <b>you</b>."
         let attributedString = html.htmlAttributedString(with: "Futura", fontSize: 14, colorHex: "ff0000")
         
         }
         test()*/
    }
    
}
