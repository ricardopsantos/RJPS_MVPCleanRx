//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable no_print

// MARK: - Logger (Public)

extension RJSLib {

    public struct Logger {
        private init() {}

        public enum Tag: String {
            case generic
        }

        private static var _logMessagesPrefix = "\(RJSLib.self).\(Logger.self)"
        private static var _debugCounter: Int = 0
        public static func cleanStoredLogs() {
            StorageUtils.deleteLogs()
        }

        public static func message(_ message: Any?, tag: String = RJSLib.Logger.Tag.generic.rawValue,
                                   function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "[Debug] [\(tag)]"
            private_print("\(prefix)\(message!)", function: function, file: file, line: line)
        }

        public static func warning(_ message: Any?, tag: String = RJSLib.Logger.Tag.generic.rawValue,
                                   function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "[Warning] [\(tag)]"
            private_print("\(prefix)\(message!)", function: function, file: file, line: line)
        }

        public static func error(_ message: Any?, tag: String = RJSLib.Logger.Tag.generic.rawValue,
                                 shouldCrash: Bool = false,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "[Error] [\(tag)]"
            private_print("\(prefix)\(message!)", function: function, file: file, line: line)
        }
        
        //
        // Log to console/terminal
        //
        
        private static func private_print(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
            
            // When performed on physical device, NSLog statements appear in the device's console whereas
            // print only appears in the debugger console.
            
            let appState = ""
            
            _debugCounter     += 1
            let senderCodeId   = RJS_Utils.senderCodeId(function, file: file, line: line)
            let messageToPrint = message.trim
            let date           = Date.utcNow
            var logMessage     = ""
            if appState.isEmpty {
                logMessage = "# [\(_debugCounter)][\(_logMessagesPrefix)][\(senderCodeId)][\(date)]\n\(messageToPrint)"
            } else {
                logMessage = "# [\(_debugCounter)][\(_logMessagesPrefix)][\(appState)][\(senderCodeId)][\(date)]\n\(messageToPrint)"
            }
            
            StorageUtils.appendToFile(logMessage)
            
            if !RJS_Utils.isSimulator {
                NSLog("%@\n", logMessage)
            } else {
                // NAO APAGAR O "Swift", senao a app pensa que é a esta mm funcao e entra em loop
                Swift.print(logMessage+"\n")
            }
        }
    }
}

// MARK: - Logger (Private)

fileprivate extension RJSLib.Logger {

    struct StorageUtils {

        fileprivate static var logFile: URL? {
             guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
             return documentsDirectory.appendingPathComponent("\(RJSLib.self).\(RJSLib.Logger.self).log")
        }

        static func deleteLogs() {
            guard let logFile = logFile else {  return }
            guard FileManager.default.isDeletableFile(atPath: logFile.path) else { return }
            try? FileManager.default.removeItem(atPath: logFile.path)
        }

        static func appendToFile(_ log: String) {
              guard let logFile = logFile else {  return }
              guard let data = ("\(log)\n").data(using: String.Encoding.utf8) else { return }
              if FileManager.default.fileExists(atPath: logFile.path) {
                  if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                      fileHandle.seekToEndOfFile()
                      fileHandle.write(data)
                      fileHandle.closeFile()
                  }
              } else {
                  try? data.write(to: logFile, options: .atomicWrite)
              }
          }
    }
}
