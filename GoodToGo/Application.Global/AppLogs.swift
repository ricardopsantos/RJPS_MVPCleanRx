//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

struct AppLogs {
    static func DLog(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        guard (AppCan.Logs.doLogs) else { return }
        RJS_Logs.DLog(message, function: function, file: file, line: line)
    }
    
    static func DLog(appCode: AppEnuns.AppCodes, function: String = #function, file: String = #file, line: Int = #line) {
        guard (AppCan.Logs.doLogs) else { return }
        RJS_Logs.DLog(appCode.localizedMessageForDevTeam, function: function, file: file, line: line)
    }
    
    static func DLogWarning(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        guard (AppCan.Logs.doLogs) else { return }
        RJS_Logs.DLogWarning(message, function: function, file: file, line: line)
    }
    
    static func DLogError(_ message: Any?, function: String = #function, file: String = #file, line: Int = #line) {
        guard (AppCan.Logs.doLogs) else { return }
        RJS_Logs.DLogError(message, function: function, file: file, line: line)
    }
    

}


