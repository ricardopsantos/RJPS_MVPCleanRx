//
//  Dictionary.swift
//  RJPSLib
//
//  Created by Ricardo Santos on 11/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}
