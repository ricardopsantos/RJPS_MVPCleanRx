//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//
import AppConstants
import PointFreeFunctions

public extension DevTools {
    struct AppLogger {
        public static var enabled = false

        public static func log(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
            guard enabled else { return }
            RJS_Logs.message(message, function: function, file: file, line: line)
        }

        public static func warning(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
            guard enabled else { return }
            RJS_Logs.warning(message, function: function, file: file, line: line)
        }

        public static func error(_ message: Any?, function: String = #function, file: String = #file, line: Int = #line) {
            guard enabled && message != nil else { return }
            DevTools.makeToast("\(message!)", isError: true, function: function, file: file, line: line)
            RJS_Logs.error(message, function: function, file: file, line: line)
        }
    }
}
