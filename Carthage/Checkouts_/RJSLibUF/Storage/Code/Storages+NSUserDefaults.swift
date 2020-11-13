//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJSLibUFBase

public extension RJSLib.Storages {
    struct NSUserDefaults {
        private init() {}
        
        public static func deleteWith(key: String) {
            guard !key.isEmpty else {
                return
            }
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: key)
            defaults.synchronize()
        }
        
        public static func save(_ objectToSave: AnyObject?, key: String) {
            guard !key.isEmpty else {
                return
            }
            
            if objectToSave == nil {
                deleteWith(key: key)
                return
            }
            
            let defaults = UserDefaults.standard
            let dataVal: Data = NSKeyedArchiver.archivedData(withRootObject: objectToSave!)
            defaults.set(dataVal, forKey: key)
            defaults.synchronize()
        }
        
        @discardableResult public static func existsWith(key: String?) -> Bool {
            return UserDefaults.standard.object(forKey: key!) != nil
        }
        
        @discardableResult public static func getWith(key: String) -> AnyObject? {
            guard !key.isEmpty else { return nil }
            let defaults = UserDefaults.standard
            if let object = defaults.object(forKey: key) {
                if let nsdata = object as? Data {
                    let result = NSKeyedUnarchiver.unarchiveObject(with: nsdata)
                    return result as AnyObject
                } else {
                    return object as AnyObject
                }
            }
            return nil
        }
    }
}
