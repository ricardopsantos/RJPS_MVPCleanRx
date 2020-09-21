//
//  GoodToGo
//
//  Created by Ricardo Santos 
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RxSwift
//
import Factory

// swiftlint:disable rule_Coding

public extension UserDefaults {
    func save(kvStorableRecord: GenericKeyValueStorable) {
        UserDefaults.standard.set(kvStorableRecord.toData, forKey: kvStorableRecord.key)
    }
}

public extension RP {
    class APICacheManager: APICacheManagerProtocol {

        public init() { }
        
        private var hotCache = NSCache<NSString, GenericKeyValueStorable>()

        public func save<T: Codable>(_ some: T, key: String, params: [String], lifeSpam: Int = 5) {
            let kvStorableRecord = GenericKeyValueStorable(some, key: key, params: params, lifeSpam: lifeSpam)
            hotCacheAdd(kvStorableRecord: kvStorableRecord, withKey: kvStorableRecord.key)
            coldCacheAdd(kvStorableRecord: kvStorableRecord)
        }

        // Get Sync
        public func getSync<T: Codable>(key: String, params: [String], type: T.Type) -> T? {
            let composedKey = CacheUtils.composedKey(key, params)
            return cacheGet(composedKey: composedKey, type: type)
        }

        public func genericCacheObserver<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String], apiObserver: Single<T>) -> Observable<T> {
            let cacheObserver = Observable<T>.create { [weak self] observer in
                if let cached = self?.getSync(key: cacheKey, params: keyParams, type: some) {
                    if let array = cached as? [Codable], array.count > 0 {
                        // If the response is an array, we only consider it if the array have elements
                         observer.on(.next(cached))
                         observer.on(.completed)
                     } else {
                         observer.on(.next(cached))
                         observer.on(.completed)
                     }
                }
                observer.on(.error(Factory.Errors.with(appCode: .notFound)))
                observer.on(.completed)
                return Disposables.create()
            }.catchError { (_) -> Observable<T> in
                // No cache. Returning API call...
                return apiObserver.asObservable()
            }
            return cacheObserver
        }
    }
}

fileprivate extension RP.APICacheManager {
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

fileprivate extension RP.APICacheManager {

    func hotCacheAdd(kvStorableRecord: GenericKeyValueStorable, withKey: String) {
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

private extension RP.APICacheManager {

    func coldCacheAdd(kvStorableRecord: GenericKeyValueStorable) {
        UserDefaults.standard.save(kvStorableRecord: kvStorableRecord)
    }

    func coldCacheGet<T: Codable>(composedKey: String, type: T.Type) -> T? {
        if let cached = UserDefaults.standard.data(forKey: composedKey),
            let dRes = try? JSONDecoder().decode(GenericKeyValueStorable.self, from: cached),
            let value = dRes.value,
            let data = value.data(using: .utf8),
            let result = try? JSONDecoder().decode(type, from: data) {
                return result
            }
        return nil
    }
}
