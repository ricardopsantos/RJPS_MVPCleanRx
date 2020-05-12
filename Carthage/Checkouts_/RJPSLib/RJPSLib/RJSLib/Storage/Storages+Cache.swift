//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension RJSLib.Storages {

    /// Uses NSCache
    struct CacheLive {
        private init() {}

        private static var _cache = NSCache<NSString, AnyObject>()

        public static func add(object: AnyObject, withKey: String) {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            _cache.setObject(object as AnyObject, forKey: withKey as NSString)
        }

        public static func get(key: String) -> AnyObject? {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            if let object = _cache.object(forKey: key as NSString) { return object }
            return nil
        }

        public static func clean(sender: String="") {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            if !sender.trim.isEmpty {
                RJS_Logs.DLog("Cache cleaned by [\(sender)]")
            }
            _cache.removeAllObjects()
        }
    }

    /// Uses CoreData
    struct CachePersistant {
        public enum CacheStrategy {
            case reloadIgnoringCache  // Cache ignored, and returns latest available value
            case returnCacheElseLoad  // Will use cache if available, else returns latest available value (good because avoids server calls)
            case cacheAndLatestValue  // Can emit twice, one for cache (if available) and other with the latest available value

            public var canUseCache: Bool {
                return self != .reloadIgnoringCache
            }
        }
    }
}
