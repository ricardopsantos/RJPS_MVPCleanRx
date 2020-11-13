//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

//
// typealias? Why?
//
// 1 : When using RJSLib on other projects, instead of using `RJSLib.AppAndDeviceInfo`, we can use `RJS_DeviceInfo` which can be more elegant and short to use
// 2 : When using RJSLib, we can type `RJS_` and the Xcode auto-complete feature will suggest only thing inside RJSLib
// 3 : If one day the module `RJSLib.Designables.SearchBar` changes place for something like `RJSLib.UIComponents.SearchBar`,
// the external apps using the alias wont need to change anything because the alias stays the same
//

// MARK: - Utils

public typealias RJS_AppInfo          = RJSLib.AppAndDeviceInfo   // Utilities for apps and device info. Things like `isSimulator`, `hasNotch`, etc
public typealias RJS_DeviceInfo       = RJSLib.AppAndDeviceInfo   // Same as RJS_AppInfo
public typealias RJS_Constants        = RJSLib.Constants          // Util constants like `defaultDelay`, etc
public typealias RJS_Logs             = RJSLib.Logger             // Simple logger. Handles verbose, warning and errors
public typealias RJS_Utils            = RJSLib.Utils              // Utilities like `onDebug`, `onRelease`, `executeOnce`, etc
public typealias RJS_Reachability     = RJSLib.Reachability       // Reachability helper. Contains `Reachability.isConnectedToNetwork()`
public typealias RJS_Cronometer       = RJSLib.Cronometer         // Utilities class for measure operations time
public typealias RJS_Convert          = RJSLib.Convert            // Types conversion utilities. Things like `isBase64`, `toB64String`, `toBinary`, etc

// MARK: - Designables

public typealias RJS_Designables                   = RJSLib.Designables
public typealias RJS_Designables_SearchBar         = RJSLib.Designables.SearchBar
public typealias RJS_Designables_ActivityIndicator = RJSLib.Designables.ActivityIndicator

// MARK: - Cool Stuff

public typealias RJS_SynchronizedArray = SynchronizedArray
