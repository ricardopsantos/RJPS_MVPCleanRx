//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

//swiftlint:disable rule_UIColor_1 rule_UIFont_1

import UIKit
import Foundation
//
import RJPSLib_Base
import RJPSLib_Storage
import RJPSLib_Networking
import RJSPLib_AppThemes
//
import AppConstants
import AppTheme
import AppResources
import UIBase
import DevTools
import Designables

//
// MARK: - RJPSLib Shortcuts
//
// https://github.com/ricardopsantos/RJPSLib
// Turning the RJPSLib alias into something more readable and related to this app it self
//

typealias AppInfo                = RJPSLib_Base.RJSLib.AppAndDeviceInfo                         // Utilities for apps and device info. Things like `isSimulator`, `hasNotch`, etc
typealias AppUtils               = RJPSLib_Base.RJSLib.Utils                                    // Utilities like `onDebug`, `onRelease`, `executeOnce`, etc
typealias AppCoreDataManager     = RJPSLib_Storage.DataModelEntetie                             // Alias over `public class DataModelEntetie: NSManagedObject`
typealias AppUserDefaultsVars    = RJPSLib_Storage.RJSLib.Storages.NSUserDefaultsStoredVarUtils // NSUserDefaults utilities for Int Type
typealias AppUserDefaults        = RJPSLib_Storage.RJSLib.Storages.NSUserDefaults               // NSUserDefaults utilities (save, delete, get, exits, ...)
typealias WebAPIRequestProtocol  = RJPSLib_Networking.SimpleNetworkClientRequest_Protocol
typealias AppSimpleNetworkClient = RJPSLib_Networking.RJSLib.SimpleNetworkClient
