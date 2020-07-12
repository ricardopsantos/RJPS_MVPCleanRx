//
//  CacheProtocols.swift
//  RJPSLib
//
//  Created by Ricardo Santos on 11/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// MARK: - RJPSLibLiveSimpleCacheProtocol

public protocol RJPSLibLiveSimpleCacheProtocol {
    func add(object: AnyObject, withKey: String)
    func get(key: String) -> AnyObject?
    func delete(key: String)
    func clean()
}

// MARK: - RJPSLibPersistentSimpleCacheWithTTLProtocol

public protocol RJPSLibPersistentSimpleCacheWithTTLProtocol {
    func getObject<T: Codable>(_ some: T.Type, withKey key: String, keyParams: [String]) -> T?
    func saveObject<T: Codable>(_ some: T, withKey key: String, keyParams: [String], lifeSpam: Int) -> Bool
    func allRecords() -> [RJS_DataModel]
    func delete(key: String)
    func clean()
    func printReport()
}

public extension RJSLib.Storages {

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
