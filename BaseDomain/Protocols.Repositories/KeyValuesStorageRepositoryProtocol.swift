//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJSLibUFStorage

public protocol KeyValuesStorageRepositoryProtocol {
    @discardableResult func save(key: String, value: String, expireDate: Date?) -> Bool
    func existsWith(key: String) -> Bool
    func with(key: String) -> RJS_DataModelEntity?
    func with(prefix: String) -> RJS_DataModelEntity?
    func allKeys() -> [String]
    func allRecords() -> [RJS_DataModelEntity]
    @discardableResult func deleteAll() -> Bool
    @discardableResult func deleteWith(key: String) -> Bool
}
