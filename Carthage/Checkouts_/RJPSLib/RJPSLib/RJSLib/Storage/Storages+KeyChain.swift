//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension RJSLib.Storages {

    struct Keychain {
        private init() {}

        public static func saveToKeychain(_ value: String?, key: String) -> Bool {
            guard !key.trim.isEmpty else { return false }
            guard value != nil else {
                KeychainWrapper.standard.removeObject(forKey: key)
                return true
            }
            return KeychainWrapper.standard.set(value!, forKey: key)
        }

        @discardableResult public static func readFromKeychain(_ key: String, ifNilResult: String?=nil) -> String? {
            guard !key.isEmpty else { return nil }
            if let result = KeychainWrapper.standard.string(forKey: key) {
                return result
            }
            return ifNilResult
        }

        public static func deleteFromKeychain(_ key: String) {
            _ = saveToKeychain(nil, key: key)
        }
    }

}
