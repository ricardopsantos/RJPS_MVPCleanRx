//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension RJSLib.Storages {
    
    /// Uses NSCache
    struct CacheLive: RJPSLibLiveSimpleCacheProtocol {
        
        private init() {}
        public static let shared = RJS_LiveCache()

        private var _cache = NSCache<NSString, AnyObject>()
        
        public func add(object: AnyObject, withKey: String) {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            _cache.setObject(object as AnyObject, forKey: withKey as NSString)
        }
        
        public func get(key: String) -> AnyObject? {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            if let object = _cache.object(forKey: key as NSString) { return object }
            return nil
        }

        public func delete(key: String) {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            _cache.removeObject(forKey: key as NSString)
        }

        public func clean() {
            objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
            _cache.removeAllObjects()
        }
    }
}
