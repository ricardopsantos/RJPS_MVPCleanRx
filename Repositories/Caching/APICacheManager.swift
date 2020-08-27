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

    public func save<T: Codable>(_ some: T, key: String, params: [String], lifeSpam: Int = 5) {
        let toCache = GenericKeyValueStorableRecord(some, key: key, params: params, lifeSpam: lifeSpam)
        UserDefaults.standard.save(kvStorableRecord: toCache)
    }

    // Get Sync
    public func getSync<T: Codable>(key: String, params: [String], type: T.Type) -> T? {
        let composedKey = CacheUtils.composedKey(key, params)
        return get(composedKey: composedKey, type: type)
    }
}

private extension APICacheManager {

    func get<T: Codable>(composedKey: String, type: T.Type) -> T? {
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
