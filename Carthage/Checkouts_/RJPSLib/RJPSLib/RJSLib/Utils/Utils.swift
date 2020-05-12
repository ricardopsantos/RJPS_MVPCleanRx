//
//  GoodToGo
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
             DispatchQueue.executeWithDelay(delay: delay) {
                 block()
             }
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
        
        public static func isSandboxApp() -> Bool {
            #if DEBUG
            // For Simulator, and apps created with Xcode
            return true
            #else
            // For AppStore and Archive
            return false
            #endif
        }
        
        // Just for iPhone simulador
        public static var isSimulator: Bool { return RJS_DeviceInfo.isSimulator }
        public static var isRealDevice: Bool { return isSimulator }
        
        public static func senderCodeId(_ function: String = #function, file: String = #file, line: Int = #line, showLine: Bool=isRealDevice) -> String {
            let fileName = file.splitBy("/").last!
            var sender   = "\(fileName) | \(function)"
            if showLine {
                sender =  "\(sender) | \(line)"
            }
            return sender.replace(" ", with: "")
        }
        
        public static func existsInternetConnection() -> Bool {
            return Reachability.isConnectedToNetwork()
        }
        
        // https://www.swiftbysundell.com/posts/under-the-hood-of-assertions-in-swift
        // @autoclosure to avoid evaluating expressions in non-debug configurations
        public static func assert(_ value:@autoclosure() -> Bool, message:@autoclosure() -> String="", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
            guard isSimulator else { return
            }
            if !value() {
                RJS_Logs.DLogError("Assert condition not meeted! \(message())" as AnyObject, function: "\(function)", file: "\(file)", line: line)
            }
        }
        
    }
    
    public class Reachability {
        public class func isConnectedToNetwork() -> Bool {
            var zeroAddress              = sockaddr_in()
            zeroAddress.sin_len          = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family       = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable     = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
    }
}
