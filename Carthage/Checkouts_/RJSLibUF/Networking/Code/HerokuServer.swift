//
//  Created by Ricardo P Santos on 2018.
//  Copyright © 2018 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
/*
public extension RJSLib {
    
    class HerokuServer {
        
        private init() {}
        
        var serverA = ""
        var serverB = ""
        public init(serverA: String, serverB: String) {
            self.serverA = serverA
            self.serverB = serverB
        }
        
        private var serverSignature: String {
            var result = "uSignture"
            result.append(contentsOf: "/"+RJS_Convert.Base64.toB64String("AppInfo:\(RJS_DeviceInfo.appInfo)" as AnyObject))
            result.append(contentsOf: "/"+RJS_Convert.Base64.toB64String("sToken" as AnyObject))
            result.append(contentsOf: "/"+RJS_Convert.Base64.toB64String("1" as AnyObject))
            result.append(contentsOf: "/"+RJS_Convert.Base64.toB64String("DeviceInfo:\(RJS_DeviceInfo.deviceInfo)" as AnyObject))
            return result
        }
        
        private func serverURL(url:@escaping (String) -> Void) {
            func testAndSwap(server1: String, server2: String) {
                RJS_BasicNetworkClient.getJSONFrom(urlString: serverA+"/test") { (some, success) in
                    if some != nil && success {
                        url(server1)
                    } else {
                        url(server2)
                    }
                }
            }
            if Date.utcNow.hours<12 {
                testAndSwap(server1: serverA, server2: serverB)
            } else {
                testAndSwap(server1: serverB, server2: serverA)
            }
        }
        
        public func sendMessageToServer(_ message: String, type: String="Info") {
            serverURL { [weak self] (url) in
                guard let strongSelf = self else { return }
                let msgB64   = RJS_Convert.Base64.toB64String(message as AnyObject)
                let typeB64  = RJS_Convert.Base64.toB64String(type as AnyObject)
                let finalURL = "\(url)/comunicateMsg/\(msgB64)/\(typeB64)/\(strongSelf.serverSignature)"
                RJS_BasicNetworkClient.getJSONFrom(urlString: finalURL, completion: { (_, _) in })
            }
        }
        
        public func getValueFromServer(key: String, completition:@escaping (AnyObject?) -> Void) {
            let query = "SELECT value, enc FROM server_keys WHERE key LIKE '\(key)' LIMIT 1"
            serverURL { [weak self] (url) in
                guard let strongSelf = self else { return }
                let part1 = RJS_Convert.Base64.toB64String(query as AnyObject)
                let part2 = RJS_Convert.Base64.toB64String(query as AnyObject)
                let finalURL = "\(url)/executePGQueryWithReturnValue/\(part1)/\(part2)/\(strongSelf.serverSignature)"
                RJS_BasicNetworkClient.getJSONFrom(urlString: finalURL, completion: { (some, success) in
                    let fail = { completition(nil) }
                    if success {
                        if let something = some {
                            if let list: NSArray = something as? NSArray {
                                if list.count == 1 {
                                    let dic = list.firstObject as? [String: String]
                                    let encoding = dic!["enc"]
                                    let value    = dic!["value"]
                                    if encoding == "0" {
                                        completition(value as AnyObject?)
                                    } else if (encoding) == "1" {
                                        completition(RJS_Convert.Base64.toPlainString(value!) as AnyObject?)
                                    } else {
                                        fail()
                                    }
                                } else {
                                    fail()
                                }
                            } else {
                                fail()
                            }
                        }
                    } else {
                        fail()
                    }
                })
            }
        }
    }
    
}
*/
