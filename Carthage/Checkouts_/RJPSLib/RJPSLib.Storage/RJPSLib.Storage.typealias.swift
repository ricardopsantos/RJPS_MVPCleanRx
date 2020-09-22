//
//  RJPSLib.Storage.typealias.swift
//  RJPSLib.Storage
//
//  Created by Ricardo Santos on 12/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

//
// typealias? Why?
//
// When using RJSLib on other projects, instead of using `DataModelEntetie.PersistentSimpleCacheWithTTL`, we can use `RJS_PersistentCacheWithTTL` which can be more elegant and short to use
// Also, when using RJSLib, we can type `RJS_` and the Xcode auto-complete feature will suggest only thing inside RJSLib
//

extension RJSLib {
    public struct  Storages { private init() {} }
}

// MARK: - Storage Support

public typealias RJS_LiveCache              = RJSLib.Storages.CacheLive                      // Storage utils, using NSCache (cache lost on device restart)
public typealias RJS_PersistentCacheWithTTL = DataModelEntetie.PersistentSimpleCacheWithTTL  // Storage utils, using CoreData (cache is persistent)
public typealias RJS_DataModel              = DataModelEntetie                               // Alias over `public class DataModelEntetie: NSManagedObject`
public typealias RJS_StorableKeyValue       = DataModelEntetie.StorableKeyValue              // Alias over an entity that can persist information over a specific period of time

public typealias RJS_DataModelManager = RJSLib.CoreDataManager

// MARK: - Storage Support

public typealias RJS_Keychain         = RJSLib.Storages.Keychain                     // Keychain utils (add, get, delete, ...)
public typealias RJS_Files            = RJSLib.Storages.Files                        // Files utils (delete, save, files on folder, ...)
public typealias RJS_UserDefaults     = RJSLib.Storages.NSUserDefaults               // NSUserDefaults utilities (save, delete, get, exits, ...)
public typealias RJS_UserDefaultsVars = RJSLib.Storages.NSUserDefaultsStoredVarUtils // NSUserDefaults utilities for Int Type
