//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

struct AppGlobal {
    
    public static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    public static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    
    static func assert(_ value: @autoclosure() -> Bool,
                       message: @autoclosure() -> String="",
                       function: StaticString = #function,
                       file: StaticString = #file,
                       line: Int = #line) {
        RJS_Utils.assert(value(), message: message(), function: function, file: file, line: line)
    }

    static func saveWith(key: String, value: String, expireDate: Date?=nil) { _ = RJS_DataModel.save(key: key, value: value, expireDate: expireDate) }
    static func getWith(key: String) -> String? { if let obj = RJS_DataModel.with(key: key) { return obj.value } else { return nil } }
    static func saveContext() { RJS_DataModelManager.saveContext() }

}
