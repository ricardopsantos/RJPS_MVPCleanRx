//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension RJSLib.Storages {
    struct NSUserDefaultsStoredVarUtils {
        private init() {}

        @discardableResult public static func getIntWithKey(_ key: String) -> Int {
            if let value = RJSLib.Storages.NSUserDefaults.getWith(key) {
                return RJSLib.Convert.toInt("\(value)")
            }
            return 0
        }

        @discardableResult public static func setIntWithKey(_ key: String, value: Int) -> Int {
            RJSLib.Storages.NSUserDefaults.save("\(value)" as AnyObject, key: key)
            return getIntWithKey(key)
        }

        @discardableResult public static func incrementIntWithKey(_ key: String) -> Int {
            let stored = getIntWithKey(key)
            RJSLib.Storages.NSUserDefaults.save("\(stored+1)" as AnyObject, key: key)
            return getIntWithKey(key)
        }

        @discardableResult public static func decrementIntWithKey(_ key: String) -> Int {
            let stored = getIntWithKey(key)
            RJSLib.Storages.NSUserDefaults.save("\(stored-1)" as AnyObject, key: key)
            return getIntWithKey(key)
        }
    }
}
