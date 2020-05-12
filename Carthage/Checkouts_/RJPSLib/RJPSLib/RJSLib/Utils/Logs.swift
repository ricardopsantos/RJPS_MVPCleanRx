//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable no_print

extension RJSLib {
    
    public struct Logs {
        private init() {}
  
        private static var _logsFile: String { return "RJSLib.AppLogs.txt" }
        public static func cleanLogsFile() {
            RJS_Files.deleteFile(_logsFile, folder: .documents)
        }
        
        public static func getLogsFileContect() -> String {
            return RJS_Files.readContentOfFile(_logsFile) ?? ""
        }
        
        public static func DLog(_ message: Any?, function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let char = RJS_Utils.isSimulator ? "📝 " : "[Debug] "
            let messageToPrint = message != nil ? "\(message!)" : "(nil)"
            private_print("\(char)\(messageToPrint)", function: function, file: file, line: line)
        }
        
        public static func DLogError(_ message: Any?, shouldCrash: Bool=false, function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let char = RJS_Utils.isSimulator ? "🚫 " : "[Error] "
            let messageToPrint = message != nil ? "\(message!)" : "(nil)"
            private_print("\(char)\(messageToPrint)", function: function, file: file, line: line)
        }
        
        public static func DLogWarning(_ message: Any?, function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let char = RJS_Utils.isSimulator ? "🔶 " : "[Warning] "
            let messageToPrint = message != nil ? "\(message!)" : "(nil)"
            private_print("\(char)\(messageToPrint)", function: function, file: file, line: line)
        }
        
        //
        // Log to console/terminal
        //
        
        private static var debugCounter: Int = 0
        private static func private_print(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
            
            // When performed on physical device, NSLog statements appear in the device's console whereas
            // print only appears in the debugger console.
            
            let appState = ""
            
            debugCounter      += 1
            let senderCodeId   = RJS_Utils.senderCodeId(function, file: file, line: line)
            let messageToPrint = message.trim
            let date           = Date.utcNow
            var logMessage     = ""
            if appState.isEmpty {
                logMessage = "# [rjpsLib_logs | \(debugCounter)] # \(senderCodeId):\(date)\n\(messageToPrint)"
            } else {
                logMessage = "# [rjpsLib_logs] [\(debugCounter):\(appState)] # \(senderCodeId):\(date)\n\(messageToPrint)"
            }
            
            RJS_Files.appendToFile(_logsFile, toAppend: logMessage, folder: .documents, overWrite: false)
            
            if !RJS_Utils.isSimulator {
                NSLog("%@\n", logMessage)
            } else {
                // NAO APAGAR O "Swift", senao a app pensa que é a esta mm funcao e entra em loop
                Swift.print(logMessage+"\n")
            }
        }
    }
}
