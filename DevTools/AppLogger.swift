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

public struct AppLogger {
    public static var enabled = false

    public static func log(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        guard enabled else { return }
        RJS_Logs.DLog(message, function: function, file: file, line: line)
    }
        
    public static func warning(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        guard enabled else { return }
        RJS_Logs.DLogWarning(message, function: function, file: file, line: line)
    }
    
    public static func error(_ message: Any?, function: String = #function, file: String = #file, line: Int = #line) {
        guard enabled else { return }
        RJS_Logs.DLogError(message, function: function, file: file, line: line)
    }
}
