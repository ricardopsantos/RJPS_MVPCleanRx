//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension String {
    var nsString: NSString { return self as NSString }
    var nsRange: NSRange { return NSRange(location: 0, length: length) }
    var detectDates: [Date]? { return try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue).matches(in: self, range: nsRange).compactMap { $0.date } }
}

public extension Date {

    static var utcNow: Date { return Date() }
    
    var seconds: Int { return ((Calendar.current as NSCalendar).components([.second], from: self).second)! }
    var minutes: Int { return ((Calendar.current as NSCalendar).components([.minute], from: self).minute)! }
    var hours: Int { return ((Calendar.current as NSCalendar).components([.hour], from: self).hour)! }
    var day: Int { return ((Calendar.current as NSCalendar).components([.day], from: self).day)! }
    var month: Int { return ((Calendar.current as NSCalendar).components([.month], from: self).month)! }
    var year: Int { return ((Calendar.current as NSCalendar).components([.year], from: self).year)! }
    
    func add(days: Int) -> Date { return self.add(hours: days * 24) }
    func add(hours: Int) -> Date { return self.add(minutes: hours * 60) }
    func add(minutes: Int) -> Date { return self.add(seconds: minutes * 60) }
    func add(seconds: Int) -> Date { return self.addingTimeInterval(Double(seconds)) }
    func add(month: Int) -> Date { return NSCalendar.current.date(byAdding: .month, value: month, to: self)! }
    
    static func with(_ dateToParse: String, dateFormat: String="yyyy-MM-dd'T'HH:mm:ssXXX") -> Date? {
        guard !dateToParse.contains(subString: "null") else { return nil }
        guard !dateToParse.contains(subString: "nil") else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // http://userguide.icu-project.org/formatparse/datetime
        if let result = dateFormatter.date(from: dateToParse) { return result }
        if let date = dateToParse.detectDates?.first { return date }
        return Date.utcNow
    }
    
    func isBiggerThan(_ dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    func timeAgoString(resources: [String]=["sec ago", "min ago", "hrs ago", "days ago", "weeks ago"]) -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) \(resources[0])"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) \(resources[1])"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) \(resources[2])"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) \(resources[3])"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) \(resources[4])"
    }    
}
