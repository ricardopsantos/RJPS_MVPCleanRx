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
    
    struct Utils {
        private init() {}

        static func isSandboxApp() -> Bool {
            #if DEBUG
            // For Simulator, and apps created with Xcode
            return true
            #else
            // For AppStore and Archive
            return false
            #endif
        }
        
        // Just for iPhone simulador
        public static func isiPhoneSimulator() -> Bool { return DeviceInfo.isiPhoneSimulator() }
        public static func isSimulator()       -> Bool { return DeviceInfo.isSimulator() }
        public static func isRealDevice()      -> Bool { return !isSimulator() }
        
        public static func senderCodeId(_ function: String = #function, file: String = #file, line: Int = #line, showLine:Bool=isRealDevice()) -> String {
            let fileName = file.splitBy("/").last!
            var sender   = "\(fileName) | \(function)"
            if(showLine) {
                sender =  "\(sender) | \(line)"
            }
            return sender.replace(" ", with: "")
        }
        
        public static func existsInternetConnection() -> Bool {
            return Reachability.isConnectedToNetwork()
        }
        
        // https://www.swiftbysundell.com/posts/under-the-hood-of-assertions-in-swift
        // @autoclosure to avoid evaluating expressions in non-debug configurations
        static func ASSERT_TRUE(_ value:@autoclosure()->Bool, message:@autoclosure()->String="", function: StaticString = #function, file: StaticString = #file, line: Int = #line) -> Void {
            guard isSimulator() else { return
            }
            if(!value()) {
                RJSLib.Logs.DLogError("Assert condition not meeted! \(message())" as AnyObject, function: "\(function)", file: "\(file)", line: line)
            }
        }
        
    }
    
    open class Reachability {
        class func isConnectedToNetwork() -> Bool {
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



