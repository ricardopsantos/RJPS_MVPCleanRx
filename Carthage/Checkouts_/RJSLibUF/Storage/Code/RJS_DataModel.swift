//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import CoreData

fileprivate extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

// MARK: - RJSStorableKeyValueWithTTLProtocol

public protocol RJSStorableKeyValueWithTTLProtocol {
    static func save(key: String, value: String, expireDate: Date?) -> Bool
    static func existsWith(key: String) -> Bool
    static func with(key: String) -> RJS_DataModel?
    static func with(keyPrefix: String) -> RJS_DataModel?
    static func allKeys() -> [String]
    static func allRecords() -> [RJS_DataModel]
    static func clean() -> Bool
    static func deleteWith(key: String) -> Bool
    static var baseDate: Date { get }
}

// MARK: - RJPSLibSimpleCacheProtocol

protocol CoreDataEntity_Protocol {
    static var entityName: String { get }
}

// MARK: - Auxiliary values

extension RJS_DataModel {
    public static var baseDate: Date { return Date() }
    internal static var validateMainThread = true
    internal static var entityName: String = "\(RJS_DataModel.self)"

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
        if keyParams.count > 0 {
            return "\(key)_\(parseKeyParams(keyParams))"
        } else {
            return key
        }
    }
    
    public class PersistentSimpleCacheWithTTL: RJPSLibPersistentSimpleCacheWithTTLProtocol {

        private init() {}
        public static var shared = PersistentSimpleCacheWithTTL()

        public func getObject<T>(_ some: T.Type, withKey key: String, keyParams: [String]) -> T? where T: Decodable, T: Encodable {
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
                assertionFailure("Error retrieving object with key [\(composedKey)]. Error [\(error)]")
            }
            return nil
        }
        
        public func saveObject<T>(_ some: T, withKey key: String, keyParams: [String], lifeSpam: Int) -> Bool where T: Decodable, T: Encodable {
            let composedKey = buildKey(key, keyParams)
            let computedKeyParams = parseKeyParams(keyParams)
            if let data = try? JSONEncoder().encode(some) {
                let valueType = "\(String(describing: type(of: some)))"
                if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
                objc_sync_enter(self); defer { objc_sync_exit(self) }
                let object: RJS_DataModel?
                if #available(iOS 10.0, *) {
                    object = RJS_DataModel(context: RJS_DataModelManager.managedObjectContext)
                } else {
                    let entityDesc = NSEntityDescription.entity(forEntityName: entityName, in: RJS_DataModelManager.managedObjectContext)
                    object = RJS_DataModel(entity: entityDesc!, insertInto: RJS_DataModelManager.managedObjectContext)
                }
                
                let checkSuccess = { }
                let saveNewRecordBlock = {
                    object!.keyBase    = key
                    object!.key        = composedKey // final key
                    object!.keyParams  = computedKeyParams
                    object!.value      = nil
                    object!.recordDate = baseDate
                    object!.expireDate = baseDate.adding(minutes: lifeSpam)
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

        public func clean() {
            _ = StorableKeyValue.deleteAllWith(tag: .cachedRecord)
        }

        public func allRecords() -> [RJS_DataModel] {
            return StorableKeyValue.allRecords().filter { $0.tag == Tags.cachedRecord.rawValue }
        }

        public func delete(key: String) {
            if let record = allRecords().filter({ (some) -> Bool in some.key == key }).first, let recordKey = record.key {
                _ = RJS_DataModel.StorableKeyValue.deleteWith(key: recordKey)
            }
        }

        public func printReport() {
            var acc = ""
            var i = 0
            allRecords().forEach { (some) in
                i += 1
                acc = "\(acc)[\(i)] - 'key'=[\(some.key!)] | 'type'=[\(some.valueType!)] | 'expire'=[\(some.expireDate!)]\n"
            }
            print("\(#function) : \(acc)")
        }
    }
    
}

// MARK: - RJSStorableKeyValueWithExpireDate_Protocol implementation

extension RJS_DataModel: CoreDataEntity_Protocol {
    
    public struct StorableKeyValue: RJSStorableKeyValueWithTTLProtocol {
        public static var baseDate: Date = RJS_DataModel.baseDate
        
        private init() {}
        
        public static func save(key: String, value: String, expireDate: Date?=nil) -> Bool {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let object: RJS_DataModel?
            if #available(iOS 10.0, *) {
                object = RJS_DataModel(context: RJS_DataModelManager.managedObjectContext)
            } else {
                let entityDesc = NSEntityDescription.entity(forEntityName: entityName, in: RJS_DataModelManager.managedObjectContext)
                object = RJS_DataModel(entity: entityDesc!, insertInto: RJS_DataModelManager.managedObjectContext)
            }
            
            let checkSuccess = { }
            let saveNewRecordBlock = {
                object!.key        = key
                object!.value      = value
                object!.recordDate = baseDate
                object!.expireDate = expireDate ?? baseDate.adding(minutes: 60 * 12 * 31)
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
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            if let record = with(key: key) {
                if baseDate > record.expireDate! {
                    _ = deleteWith(key: key)
                }
            }
            return with(key: key) != nil
        }
        
        public static func with(key: String) -> RJS_DataModel? {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            return allRecordsCopy.filter { (item) -> Bool in return item.key == key && item.expireDate! > baseDate }.first
        }
        
        public static func dateWith(key: String) -> Date? {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }

            func dateWith(_ dateToParse: String, dateFormat: String="yyyy-MM-dd'T'HH:mm:ssXXX") -> Date? {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormat
                if let result = dateFormatter.date(from: dateToParse) { return result }
                var detectDates: [Date]? { return try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue).matches(in: dateToParse, range: NSRange(location: 0, length: dateToParse.count)).compactMap { $0.date } }
                if let date = detectDates?.first { return date }
                return Date()
            }

            if let dateToParse = with(key: key)?.value {
                if let date = dateWith(dateToParse) {
                    return date
                }
            }
            return nil
        }
        
        public static func with(keyPrefix: String) -> RJS_DataModel? {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            return allRecordsCopy.filter { (item) -> Bool in return item.key!.hasPrefix(keyPrefix) && item.expireDate! > baseDate }.first
        }
        
        static private func delete(records: [RJS_DataModel]) -> Bool {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
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
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            let records = allRecordsCopy.filter({ (item) -> Bool in return item.tag == tag.rawValue })
            return delete(records: records)
        }
        
        public static func deleteWith(keyPrefix: String) -> Bool {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            let records = allRecordsCopy.filter({ (item) -> Bool in return item.key!.hasPrefix(keyPrefix) })
            return delete(records: records)
        }
        
        public static func deleteWith(key: String) -> Bool {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            let records = allRecordsCopy.filter({ (item) -> Bool in return item.key == key })
            guard records.count != 0 else { return false }
            return delete(records: records)
        }
        
        public static func clean() -> Bool {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let allRecordsCopy = allRecords()
            guard allRecordsCopy.count > 0 else { return false }
            return delete(records: allRecordsCopy)
        }
        
        public static func allRecords() -> [RJS_DataModel] {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            do {
                let fetchResult = try RJS_DataModelManager.managedObjectContext.fetch(fetchRequest)
                if let items = fetchResult as? [RJS_DataModel] {
                    return items
                }
            } catch {
                assertionFailure("\(error)")
            }
            return []
        }
        
        public static func allKeys() -> [String] {
            if validateMainThread && !Thread.isMainThread { assertionFailure("Not in main tread") }
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
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
                assertionFailure("\(error)")
            }
            return result
        }
        
    }
    
}
