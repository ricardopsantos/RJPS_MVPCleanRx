//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public struct RJSLib {
    private init() {}
}

// MARK: - Storage Support

public typealias RJS_CacheLive        = RJSLib.Storages.CacheLive         // NSCache
public typealias RJS_CacheLocal       = DataModelEntetie.SimpleCache      // CoreData
public typealias RJS_DataModel        = DataModelEntetie                  // CoreData
public typealias RJS_StorableKeyValue = DataModelEntetie.StorableKeyValue // CoreData

// MARK: - Storage Support

public typealias RJS_Keychain         = RJSLib.Storages.Keychain
public typealias RJS_Files            = RJSLib.Storages.Files
public typealias RJS_UserDefaults     = RJSLib.Storages.NSUserDefaults
public typealias RJS_UserDefaultsVars = RJSLib.Storages.NSUserDefaultsStoredVarUtils

// MARK: - Utils
public typealias RJS_AppInfo          = RJSLib.AppAndDeviceInfo
public typealias RJS_DeviceInfo       = RJSLib.AppAndDeviceInfo
public typealias RJS_DataModelManager = RJSLib.CoreDataManager
public typealias RJS_Constants        = RJSLib.Constants
public typealias RJS_Logs             = RJSLib.Logs
public typealias RJS_Utils            = RJSLib.Utils
public typealias RJS_Reachability     = RJSLib.Reachability
public typealias RJS_Cronometer       = RJSLib.RJSCronometer
public typealias RJS_Convert          = RJSLib.Convert
public typealias RJS_Persmissions     = RJSLib.PermissionsManager

// MARK: - NetWorking

public typealias RJS_SimpleNetworkClient = RJSLib.BasicNetworkClient
public typealias RJS_NetworkClient       = RJSLib.NetworkClient
public typealias RJS_WebAPIProtocol      = RJSLibWebAPIRequest_Protocol

// MARK: - Designables

public typealias RJS_Designables                   = RJSLib.Designables
public typealias RJS_Designables_SearchBar         = RJSLib.Designables.SearchBar
public typealias RJS_Designables_ActivityIndicator = RJSLib.Designables.ActivityIndicator
public typealias RJS_Designables_InputField        = RJSLib.Designables.InputField

// MARK: - Cool Stuff

public typealias RJS_SynchronizedArray = SynchronizedArray
