//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import CoreData
//
import RJSLibUFBase

extension RJSLib {
    
    public class CoreDataManager {
        
        static var dbName: String { return "RJPSLibDataModel" }
        
        public enum CustomErrors: Error {
            case managedObjectContextNotFound
            case couldNotCreateObject
            case couldNotDeleteObject
            case notImplemented
            case invalidParams
        }
        
        static var applicationDocumentsDirectory: URL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
        }()
        
        static var managedObjectModel: NSManagedObjectModel = {
            if let customKitBundle = Bundle(identifier: "com.rjps.libuf.RJSLibUFStorage") {
                if let modelURL = customKitBundle.url(forResource: dbName, withExtension: "momd") {
                    return NSManagedObjectModel(contentsOf: modelURL)!
                }
            }
            // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
            //if let modelURL = Bundle.main.url(forResource: dbName(), withExtension: "momd") {
            //    return NSManagedObjectModel(contentsOf: modelURL)!
            //}
            assertionFailure("Fail getting CoreData DB [\(dbName)]")
            return NSManagedObjectModel()
        }()
        
        func managedObjectModel(ressourceName: String) -> NSManagedObjectModel {
            return CoreDataManager.managedObjectModel
        }
        
        static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            // The persistent store coordinator for the application. This implementation creates and returns a
            // coordinator, having added the store for the application to it. This property is optional
            // since there are legitimate error conditions that could cause the creation of the store to fail.
            // Create the coordinator and store
            let coordinator   = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            let url           = applicationDocumentsDirectory.appendingPathComponent("\(dbName).sqlite") // type your database name here...
            var failureReason = "There was an error creating or loading the application's saved data."
            let options       = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true as Bool), NSInferMappingModelAutomaticallyOption: NSNumber(value: true as Bool)]
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            } catch {
                // Report any error we got.
                var dict                               = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey]        = "Failed to initialize the application's saved data" as AnyObject
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
                
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                assertionFailure("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            }
            return coordinator
        }()
        
        static var managedObjectContext: NSManagedObjectContext = {
            // Returns the managed object context for the application (which is already bound to the persistent store
            // coordinator for the application.) This property is optional since there are legitimate
            // error conditions that could cause the creation of the context to fail.
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            return managedObjectContext
        }()
        
        public static func saveContext() {
            DispatchQueue.main.async {
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        assertionFailure("\(error)")
                    }
                }
            }
        }
    }
}
