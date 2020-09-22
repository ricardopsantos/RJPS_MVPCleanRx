//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension RJSLib.Storages {
    
    class Keychain {

        private init() {}
        public static var shared = RJS_Keychain()

        public func add(_ object: String, withKey: String) -> Bool {
            guard !withKey.self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
            return KeychainWrapper.standard.set(object, forKey: withKey)
        }
        
        public func get(key: String) -> String? {
            guard !key.isEmpty else { return nil }
            if let result = KeychainWrapper.standard.string(forKey: key) {
                return result
            }
            return nil
        }
        
        public func clean() {
            KeychainWrapper.standard.allKeys().forEach { (key) in
                delete(key: key)
            }
        }

        public func delete(key: String) {
            KeychainWrapper.standard.removeObject(forKey: key)
        }
    }
    
}
