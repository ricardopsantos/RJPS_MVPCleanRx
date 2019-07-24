//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension String {
    var nsString: NSString { return self as NSString }
    var nsRange: NSRange { return NSRange(location: 0, length: length) }
    var detectDates: [Date]? { return try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue).matches(in: self, range: nsRange).compactMap{$0.date} }
}

extension Date {

    public static func utcNow() -> Date { return Date() }
    
    public static func with(_ dateToParse:String, dateFormat:String="yyyy-MM-dd'T'HH:mm:ssXXX") -> Date? {
        guard dateToParse != "<null>" else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // http://userguide.icu-project.org/formatparse/datetime
        if let result = dateFormatter.date(from: dateToParse) { return result }
        if let date = dateToParse.detectDates?.first { return date }
        return Date.utcNow()
    }
}

