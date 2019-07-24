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

protocol StorableKeyValueWithExpireDate_Protocol {
    static func save(key:String, value:String, expireDate:Date?) -> Bool
    static func existsWith(key:String) -> Bool
    static func with(key:String) -> RJSLib_CoreDataKeyValue?
}

protocol CoreDataEntetie_Protocol {
    static var entetieName : String { get }
}

extension RJSLib_CoreDataKeyValue : CoreDataEntetie_Protocol, StorableKeyValueWithExpireDate_Protocol {
    static var entetieName : String = "RJSLib_CoreDataKeyValue"
    private static var validateMainThread = true
    static func baseDate() -> Date { return Date() }
    
    static func save(key:String, value:String, expireDate:Date?=nil) -> Bool {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|save : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let object : RJSLib_CoreDataKeyValue?
        if #available(iOS 10.0, *) {
            object = RJSLib_CoreDataKeyValue(context: RJSLib.CoreDataManager.managedObjectContext)
        }
        else {
            let entityDesc = NSEntityDescription.entity(forEntityName: entetieName, in: RJSLib.CoreDataManager.managedObjectContext)
            object = RJSLib_CoreDataKeyValue(entity: entityDesc!, insertInto: RJSLib.CoreDataManager.managedObjectContext)
        }
        
        let checkSucess = { }
        let saveNewRecordBlock = {
            object!.key        = key
            object!.value      = value
            object!.recordDate = baseDate()
            object!.expireDate = expireDate ?? Calendar.current.date(byAdding: .day, value: 365, to: baseDate())
            RJSLib.CoreDataManager.saveContext()
            checkSucess()
        }
        if(object != nil) {
            let _ = deleteWith(key:key)
            saveNewRecordBlock()
        }
        else {
            saveNewRecordBlock()
        }
        return true
    }
    
    static func existsWith(key:String) -> Bool {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|existsWith : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        if let record = with(key: key) {
            if(record.expireDate! > baseDate()) {
                let _ = deleteWith(key: key)
            }
        }
        return with(key: key) != nil
    }
    
    static func with(key:String) -> RJSLib_CoreDataKeyValue? {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|with : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let allRecordsCopy = allRecords()
        return allRecordsCopy.filter { (item) -> Bool in return item.key == key && item.expireDate! < baseDate() }.first
    }
    
    static func dateWith(key:String) -> Date? {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|dateWith : Not in main tread") }
        if let dateToParse = with(key: key)?.value {
            if let date = Date.with(dateToParse) {
                return date
            }
        }
        return nil
    }
    
    static func with(keyPrefix:String) -> RJSLib_CoreDataKeyValue? {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|with : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let allRecordsCopy = allRecords()
        return allRecordsCopy.filter { (item) -> Bool in return item.key!.hasPrefix(keyPrefix) && item.expireDate! < baseDate() }.first
    }
    
    static private func delete(records:[RJSLib_CoreDataKeyValue]) -> Bool {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|delete : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        if (records.count > 0) {
            records.forEach({ (item) in
                RJSLib.CoreDataManager.managedObjectContext.delete(item)
            })
            RJSLib.CoreDataManager.saveContext()
        }
        return records.count > 0
    }
    
    static func deleteWith(keyPrefix:String) -> Bool {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|deleteWith : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let allRecordsCopy = allRecords()
        let records = allRecordsCopy.filter({ (item) -> Bool in return item.key!.hasPrefix(keyPrefix) })
        return delete(records:records)
    }
    
    static func deleteWith(key:String) -> Bool {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|deleteWith : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let allRecordsCopy = allRecords()
        let records = allRecordsCopy.filter({ (item) -> Bool in return item.key == key })
        guard records.count != 0 else { return false }
        return delete(records:records)
    }
    
    static func deleteAll() -> Bool {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|deleteAll : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let allRecordsCopy = allRecords()
        guard allRecordsCopy.count > 0 else { return false }
        return delete(records:allRecordsCopy)
    }
    
    static func allRecords() -> [RJSLib_CoreDataKeyValue] {
        if(validateMainThread && !Thread.isMainThread) { print("RJSLib_CoreDataKeyValue|allRecords : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entetieName)
        do {
            let fetchResult = try RJSLib.CoreDataManager.managedObjectContext.fetch(fetchRequest)
            if let items = fetchResult as? [RJSLib_CoreDataKeyValue] {
                return items
            }
        }
        catch {
            RJSLib.Logs.DLogError(error as AnyObject)
        }
        return []
    }
    
    static func allKeys() -> [String] {
        if(validateMainThread && !Thread.isMainThread) { print("CoreDataKeyValue|allKeys : Not in main tread") }
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entetieName)
        var result : [String] = []
        do {
            let fetchResult = try RJSLib.CoreDataManager.managedObjectContext.fetch(fetchRequest)
            if let items = fetchResult as? [RJSLib_CoreDataKeyValue] {
                items.forEach { (some) in
                    if some.key != nil {
                        result.append(some.key!)
                    }
                }
            }
        }
        catch {
            RJSLib.Logs.DLogError(error as AnyObject)
        }
        return result
    }
    
}

