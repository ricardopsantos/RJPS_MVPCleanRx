//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

extension RP {
    struct LocalStorage {
        private init() {}
    }
}

extension RP.LocalStorage {
    
    class Generic_LocalStorageRepository: Generic_LocalStorageRepositoryProtocol {
        
        @discardableResult
        func save(key: String, value: String, expireDate: Date?) -> Bool {
            return RJS_DataModel.save(key: key, value: value, expireDate:expireDate)
        }
        
        func existsWith(key: String) -> Bool {
            return RJS_DataModel.existsWith(key: key)
        }
        
        func with(prefix: String) -> RJS_DataModel? {
            return RJS_DataModel.with(keyPrefix: prefix)
        }
        
        func with(key: String) -> RJS_DataModel? {
            return RJS_DataModel.with(key: key)
        }
        
        func allKeys() -> [String] {
            return RJS_DataModel.allKeys()
        }
        
        func allRecords() -> [RJS_DataModel] {
            return RJS_DataModel.allRecords()
        }
        
        @discardableResult
        func deleteAll() -> Bool {
            return RJS_DataModel.deleteAll()
        }
        
        @discardableResult func deleteWith(key: String) -> Bool {
            return RJS_DataModel.deleteWith(key: key)
        }
    }
}