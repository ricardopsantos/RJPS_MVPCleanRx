//
//  PointFreeFunctions.swift
//  PointFreeFunctions
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

public var screenWidth: CGFloat { return UIScreen.main.bounds.width }
public var screenHeight: CGFloat { return UIScreen.main.bounds.height }

public func assert(_ value: @autoclosure() -> Bool,
            message: @autoclosure() -> String="",
            function: StaticString = #function,
            file: StaticString = #file,
            line: Int = #line) {
    RJS_Utils.assert(value(), message: message(), function: function, file: file, line: line)
}

public func saveWith(key: String,
              value: String,
              expireDate: Date?=nil) {
    _ = RJS_DataModel.save(key: key, value: value, expireDate: expireDate)
}

public func getWith(key: String) -> String? {
    if let obj = RJS_DataModel.with(key: key) {
        return obj.value
    } else {
        return nil
    }
}

public func saveContext() {
    RJS_DataModelManager.saveContext()
}
