//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
//
import AppConstants
import AppTheme
import AppResources
import UIBase
import DevTools

typealias SequenceBlock          = RJS_Sequence
typealias CustomSearchBar        = RJS_CustomSearchBar
typealias DeviceInfo             = RJS_DeviceInfo

typealias AppStorages            = RJS_Storages
typealias AppInfo                = RJS_AppInfo
typealias AppCoreDataManager     = RJS_DataModel
typealias AppSimpleNetworkClient = RJS_SimpleNetworkClient
typealias AppUtils               = RJS_Utils
typealias AppCache               = RJS_Cache
typealias AppFileSystem          = RJS_Files
typealias AppUserDefaultsVars    = RJS_UserDefaultsVars
typealias AppUserDefaults        = RJS_UserDefaults
typealias WebAPIRequest_Protocol = RJSLibWebAPIRequest_Protocol

typealias AppEnvironments        = AppManagers.Environments
//typealias AppFactory             = UIBase.Factory
typealias AppCan                 = AppManagers.AppCan
//typealias AppResources           = AppManagers.Resources
//typealias AppMessages            = AppResources.Messages
typealias AppLayouts             = AppManagers.Layouts
typealias AppColors              = UIColor.App
typealias AppFonts               = UIFont.App
typealias AppImages              = UIImage.App
typealias AppProtocols           = RootAssemblyContainerProtocols

typealias AppLogger = DevTools.AppLogger
typealias GenericView = UIBase.GenericView
//typealias GenericTableView_Protocol = UIBase.GenericTableView_Protocol
typealias AppFactory = UIBase.Factory
