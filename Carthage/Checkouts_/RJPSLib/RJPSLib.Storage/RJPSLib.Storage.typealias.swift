//
//  RJPSLib.Storage.typealias.swift
//  RJPSLib.Storage
//
//  Created by Ricardo Santos on 12/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

extension RJSLib {
    public struct  Storages { private init() {} }
}

// MARK: - Storage Support

public typealias RJS_LiveCache              = RJSLib.Storages.CacheLive                     // Uses NSCache (cache lost on device restart)
public typealias RJS_PersistentCacheWithTTL = DataModelEntetie.PersistentSimpleCacheWithTTL  // Uses CoreData (cache is persistent)
public typealias RJS_DataModel              = DataModelEntetie                  // CoreData
public typealias RJS_StorableKeyValue       = DataModelEntetie.StorableKeyValue // CoreData

public typealias RJS_DataModelManager = RJSLib.CoreDataManager

// MARK: - Storage Support

public typealias RJS_Keychain         = RJSLib.Storages.Keychain
public typealias RJS_Files            = RJSLib.Storages.Files
public typealias RJS_UserDefaults     = RJSLib.Storages.NSUserDefaults
public typealias RJS_UserDefaultsVars = RJSLib.Storages.NSUserDefaultsStoredVarUtils
