//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension RJSLib {
    
    public struct Utils {
        private init() {}

        public static func delay(_ delay: Double, block: @escaping () -> Void) {
            DispatchQueue.executeWithDelay(delay: delay) { block() }
        }
        
        public static func executeOnce(token: String, block:() -> Void) -> Bool {
            return DispatchQueue.executeOnce(token: token) { block() }
        }
        
        public static func executeInMainTread(_ block:@escaping () -> Void) {
            DispatchQueue.executeInMainTread { block() }
        }
        
        public static func executeInBackgroundTread(_ block:@escaping () -> Void) {
            DispatchQueue.executeInBackgroundTread { block() }
        }

        public static var onRelease: Bool {
            return !onDebug
        }

        public static var onDebug: Bool {
            #if DEBUG
            // For Simulator, and apps created with Xcode
            return true
            #else
            // For AppStore and Archive
            return false
            #endif
        }

        public static var onSimulator: Bool {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }

        // Just for iPhone simulator
        public static var isSimulator: Bool { return RJS_DeviceInfo.isSimulator }
        public static var isRealDevice: Bool { return isSimulator }
        
        public static func senderCodeId(_ function: String = #function, file: String = #file, line: Int = #line, showLine: Bool=isRealDevice) -> String {
            let fileName = file.split(by: "/").last!
            var sender   = "\(fileName) | \(function)"
            if showLine {
                sender =  "\(sender) | \(line)"
            }
            return sender.replace(" ", with: "")
        }
        
        public static var existsInternetConnection: Bool {
            return Reachability.isConnectedToNetwork()
        }
        
        // https://www.swiftbysundell.com/posts/under-the-hood-of-assertions-in-swift
        // @autoclosure to avoid evaluating expressions in non-debug configurations
        public static func assert(_ value:@autoclosure() -> Bool,
                                  message:@autoclosure() -> String="",
                                  function: StaticString = #function,
                                  file: StaticString = #file,
                                  line: Int = #line) {
            guard onDebug else { return }
            if !value() {
                RJS_Logs.error("Assert condition not meeted! \(message())" as AnyObject, function: "\(function)", file: "\(file)", line: line)
            }
        }
    }
}
