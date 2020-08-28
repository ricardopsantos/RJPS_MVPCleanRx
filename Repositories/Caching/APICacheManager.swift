//
//  Created by Ricardo Santos on 27/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import RxSwift

// swiftlint:disable rule_Coding

public extension UserDefaults {
    func save(kvStorableRecord: GenericKeyValueStorableRecord) {
        UserDefaults.standard.set(kvStorableRecord.toData, forKey: kvStorableRecord.key)
    }
}

public class APICacheManager {
    private init() {}
    public static let shared = APICacheManager()

    private var hotCache = NSCache<NSString, GenericKeyValueStorableRecord>()

    public func save<T: Codable>(_ some: T, key: String, params: [String], lifeSpam: Int = 5) {
        let kvStorableRecord = GenericKeyValueStorableRecord(some, key: key, params: params, lifeSpam: lifeSpam)
        hotCacheAdd(kvStorableRecord: kvStorableRecord, withKey: kvStorableRecord.key)
        coldCacheAdd(kvStorableRecord: kvStorableRecord)
    }

    // Get Sync
    public func getSync<T: Codable>(key: String, params: [String], type: T.Type) -> T? {
        let composedKey = CacheUtils.composedKey(key, params)
        return cacheGet(composedKey: composedKey, type: type)
    }
}

fileprivate extension APICacheManager {
    func cacheGet<T: Codable>(composedKey: String, type: T.Type) -> T? {
        // We return first (if available) the hot cache, is faster
        if let hotCached = hotCacheGet(composedKey: composedKey, type: type) {
            return hotCached
        } else if let coldCached = coldCacheGet(composedKey: composedKey, type: type) {
            return coldCached
        }
        return nil
    }
}

// Hot cache (Faster that cold cache) : free when device starts of detects excessive memory pressure

fileprivate extension APICacheManager {

    func hotCacheAdd(kvStorableRecord: GenericKeyValueStorableRecord, withKey: String) {
        objc_sync_enter(hotCache); defer { objc_sync_exit(hotCache) }
        hotCache.setObject(kvStorableRecord, forKey: withKey as NSString)
    }

    func hotCacheGet<T: Codable>(composedKey: String, type: T.Type) -> T? {
        objc_sync_enter(hotCache); defer { objc_sync_exit(hotCache) }
        if let cached = hotCache.object(forKey: composedKey as NSString),
            let value = cached.value,
            let data = value.data(using: .utf8),
            let result = try? JSONDecoder().decode(type, from: data) {
                return result
            }
        return nil
    }
}

// Cold cache : device stored

private extension APICacheManager {

    func coldCacheAdd(kvStorableRecord: GenericKeyValueStorableRecord) {
        UserDefaults.standard.save(kvStorableRecord: kvStorableRecord)
    }

    func coldCacheGet<T: Codable>(composedKey: String, type: T.Type) -> T? {
        if let cached = UserDefaults.standard.data(forKey: composedKey),
            let dRes = try? JSONDecoder().decode(GenericKeyValueStorableRecord.self, from: cached),
            let value = dRes.value,
            let data = value.data(using: .utf8),
            let result = try? JSONDecoder().decode(type, from: data) {
                return result
            }
        return nil
    }
}
