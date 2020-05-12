//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import CoreData

// MARK: - RJPSLibSimpleCacheProtocol

public protocol RJPSLibSimpleCacheProtocol {
    static func printReport()
    static func deleteAll()
    static func allRecords() -> [RJS_DataModel]
    static func getObject<T: Codable>(_ some: T.Type, withKey key: String, keyParams: [String]) -> T?
    static func saveObject<T: Codable>(_ some: T, withKey key: String, keyParams: [String], lifeSpam: Int) -> Bool
}

// MARK: - RJSStorableKeyValueWithExpireDate_Protocol

public protocol RJSStorableKeyValueWithExpireDate_Protocol {
    static func save(key: String, value: String, expireDate: Date?) -> Bool
    static func existsWith(key: String) -> Bool
    static func with(key: String) -> RJS_DataModel?
    static func with(keyPrefix: String) -> RJS_DataModel?
    static func allKeys() -> [String]
    static func allRecords() -> [RJS_DataModel]
    static func deleteAll() -> Bool
    static func deleteWith(key: String) -> Bool
    static var baseDate: Date { get }
}

// MARK: - RJPSLibSimpleCacheProtocol

protocol CoreDataEntetie_Protocol {
    static var entetieName: String { get }
}

// MARK: - Auxiliar values

extension RJS_DataModel {
    public static var baseDate: Date { return Date() }
    internal static var validateMainThread = true
    internal static var entetieName: String = "\(RJS_DataModel.className)"
    public enum Tags: String {
        case keyValueRecord
        case cachedRecord
    }
    internal enum Encoding: String {
        case none
        case dataType
    }
}

// MARK: - RJPSLibSimpleCacheProtocol implementation

extension RJS_DataModel {

    private static func parseKeyParams(_ params: [String]) -> String {
        return "[" + params.joined(separator: ",") + "]"
    }

    private static func buildKey(_ key: String, _ keyParams: [String]) -> String {
        return "\(key)_\(parseKeyParams(keyParams))"
    }

    public struct SimpleCache: RJPSLibSimpleCacheProtocol {

        public static func deleteAll() {
            _ = StorableKeyValue.deleteAllWith(tag: .cachedRecord)
        }

        public static func printReport() {
            var acc = ""
            var i = 0
            allRecords().forEach { (some) in
                i += 1
                acc = "\(acc)[\(i)] - 'key'=[\(some.key!)] | 'type'=[\(some.valueType!)] | 'expire'=[\(some.expireDate!)]\n"
            }
            RJS_Logs.DLog(acc)
        }

        public static func allRecords() -> [RJS_DataModel] {
            return StorableKeyValue.allRecords().filter { $0.tag == Tags.cachedRecord.rawValue }
        }

        public static func getObject<T>(_ some: T.Type, withKey key: String, keyParams: [String]) -> T? where T: Decodable, T: Encodable {
            let composedKey = buildKey(key, keyParams)
            do {
                let cachedMaybe  = RJS_DataModel.StorableKeyValue.with(key: composedKey)
                guard let cached = cachedMaybe, cached.expireDate != nil else { return nil }                      // Not found
                guard cached.expireDate!.timeIntervalSinceNow > baseDate.timeIntervalSinceNow else { return nil } // expired
                if let data1 = cached.value?.data(using: String.Encoding.utf8) {
                    return try JSONDecoder().decode(T.self, from: data1)
                }
                if let data2 = cached.valueData {
                    return try JSONDecoder().decode(T.self, from: data2)
                }
            } catch {
                RJS_Logs.DLogError("Error retrieving object with key [\(composedKey)]. Error [\(error)]")
            }
            return nil
        }

        public static func saveObject<T>(_ some: T, withKey key: String, keyParams: [String], lifeSpam: Int) -> Bool where T: Decodable, T: Encodable {
            let composedKey = buildKey(key, keyParams)
            let computedKeyParams = parseKeyParams(keyParams)
            if let data = try? JSONEncoder().encode(some) {
                let valueType = "\(String(describing: type(of: some)))"
                if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
                objc_sync_enter(self); defer { objc_sync_exit(self) }
                let object: RJS_DataModel?
                if #available(iOS 10.0, *) {
                    object = RJS_DataModel(context: RJS_DataModelManager.managedObjectContext)
                } else {
                    let entityDesc = NSEntityDescription.entity(forEntityName: entetieName, in: RJS_DataModelManager.managedObjectContext)
                    object = RJS_DataModel(entity: entityDesc!, insertInto: RJS_DataModelManager.managedObjectContext)
                }

                let checkSuccess = { }
                let saveNewRecordBlock = {
                    object!.keyBase    = key
                    object!.key        = composedKey // final key
                    object!.keyParams  = computedKeyParams
                    object!.value      = nil
                    object!.recordDate = baseDate
                    object!.expireDate = baseDate.add(minutes: lifeSpam)
                    object!.encoding   = Encoding.dataType.rawValue
                    object!.valueData  = data
                    object!.valueType  = "\(valueType)"
                    object!.tag        = Tags.cachedRecord.rawValue
                    RJS_DataModelManager.saveContext()
                    checkSuccess()
                }
                if object != nil {
                    _ = StorableKeyValue.deleteWith(key: composedKey)
                    saveNewRecordBlock()
                } else {
                    saveNewRecordBlock()
                }
                return true
            }
            return false
        }
    }

}

// MARK: - RJSStorableKeyValueWithExpireDate_Protocol implementation

extension RJS_DataModel: CoreDataEntetie_Protocol {

    public struct StorableKeyValue: RJSStorableKeyValueWithExpireDate_Protocol {
        public static var baseDate: Date = RJS_DataModel.baseDate

        private init() {}

        public static func save(key: String, value: String, expireDate: Date?=nil) -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let object: RJS_DataModel?
            if #available(iOS 10.0, *) {
                object = RJS_DataModel(context: RJS_DataModelManager.managedObjectContext)
            } else {
                let entityDesc = NSEntityDescription.entity(forEntityName: entetieName, in: RJS_DataModelManager.managedObjectContext)
                object = RJS_DataModel(entity: entityDesc!, insertInto: RJS_DataModelManager.managedObjectContext)
            }

            let checkSuccess = { }
            let saveNewRecordBlock = {
                object!.key        = key
                object!.value      = value
                object!.recordDate = baseDate
                object!.expireDate = expireDate ?? baseDate.add(days: 365)
                object!.encoding   = Encoding.none.rawValue
                object!.keyBase    = nil
                object!.valueData  = nil
                object!.keyParams  = nil
                object!.valueType  = "\(value.self)"
                object!.tag        = Tags.keyValueRecord.rawValue
                RJS_DataModelManager.saveContext()
                checkSuccess()
            }
            if object != nil {
                _ = deleteWith(key: key)
                saveNewRecordBlock()
            } else {
                saveNewRecordBlock()
            }
            return true
        }

        public static func existsWith(key: String) -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            if let record = with(key: key) {
                if baseDate > record.expireDate! {
                    _ = deleteWith(key: key)
                }
            }
            return with(key: key) != nil
        }

        public static func with(key: String) -> RJS_DataModel? {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            return allRecordsCopy.filter { (item) -> Bool in return item.key == key && item.expireDate! > baseDate }.first
        }

        public static func dateWith(key: String) -> Date? {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            if let dateToParse = with(key: key)?.value {
                if let date = Date.with(dateToParse) {
                    return date
                }
            }
            return nil
        }

        public static func with(keyPrefix: String) -> RJS_DataModel? {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            return allRecordsCopy.filter { (item) -> Bool in return item.key!.hasPrefix(keyPrefix) && item.expireDate! > baseDate }.first
        }

        static private func delete(records: [RJS_DataModel]) -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            if records.count > 0 {
                records.forEach({ (item) in
                    RJS_DataModelManager.managedObjectContext.delete(item)
                })
                RJS_DataModelManager.saveContext()
            }
            return records.count > 0
        }

        public static func deleteAllWith(tag: Tags) -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            let records = allRecordsCopy.filter({ (item) -> Bool in return item.tag == tag.rawValue })
            return delete(records: records)
        }

        public static func deleteWith(keyPrefix: String) -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            let records = allRecordsCopy.filter({ (item) -> Bool in return item.key!.hasPrefix(keyPrefix) })
            return delete(records: records)
        }

        public static func deleteWith(key: String) -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            let records = allRecordsCopy.filter({ (item) -> Bool in return item.key == key })
            guard records.count != 0 else { return false }
            return delete(records: records)
        }

        public static func deleteAll() -> Bool {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            guard allRecordsCopy.count > 0 else { return false }
            return delete(records: allRecordsCopy)
        }

        public static func allRecords() -> [RJS_DataModel] {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entetieName)
            do {
                let fetchResult = try RJS_DataModelManager.managedObjectContext.fetch(fetchRequest)
                if let items = fetchResult as? [RJS_DataModel] {
                    return items
                }
            } catch {
                RJS_Logs.DLogError(error as AnyObject)
            }
            return []
        }

        public static func allKeys() -> [String] {
            if validateMainThread && !Thread.isMainThread { RJS_Logs.DLog("\(#function) : Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entetieName)
            var result: [String] = []
            do {
                let fetchResult = try RJS_DataModelManager.managedObjectContext.fetch(fetchRequest)
                if let items = fetchResult as? [RJS_DataModel] {
                    items.forEach { (some) in
                        if some.key != nil {
                            result.append(some.key!)
                        }
                    }
                }
            } catch {
                RJS_Logs.DLogError(error as AnyObject)
            }
            return result
        }

    }
    
}
