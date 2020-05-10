//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
import AppDomain

public class LocalStorageRepository: LocalStorageRepositoryProtocol {

    public init () {}

    @discardableResult public func save(key: String, value: String, expireDate: Date?) -> Bool {
        return RJS_DataModel.save(key: key, value: value, expireDate: expireDate)
    }

    public func existsWith(key: String) -> Bool {
        return RJS_DataModel.existsWith(key: key)
    }

    public func with(prefix: String) -> RJS_DataModel? {
        return RJS_DataModel.with(keyPrefix: prefix)
    }

    public func with(key: String) -> RJS_DataModel? {
        return RJS_DataModel.with(key: key)
    }

    public func allKeys() -> [String] {
        return RJS_DataModel.allKeys()
    }

    public func allRecords() -> [RJS_DataModel] {
        return RJS_DataModel.allRecords()
    }

    @discardableResult public func deleteAll() -> Bool {
        return RJS_DataModel.deleteAll()
    }

    @discardableResult public func deleteWith(key: String) -> Bool {
        return RJS_DataModel.deleteWith(key: key)
    }
}
