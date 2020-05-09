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
import Designables

//MARK:- RJPSLib Shortcuts

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

//MARK:- App Shortcuts

typealias AppEnvironments        = AppManagers.Environments
typealias AppCan                 = AppManagers.AppCan
typealias AppLayouts             = AppManagers.Layouts
typealias AppColors              = UIColor.App
typealias AppFonts               = UIFont.App
typealias AppImages              = UIImage.App
typealias AppProtocols           = RootAssemblyContainerProtocols

//MARK:- DevTools

typealias AppLogger   = DevTools.AppLogger

//MARK:- GenericView

typealias GenericView = UIBase.GenericView

//MARK:- Designables

typealias GenericTableViewCell_Protocol = Designables.GenericTableViewCell_Protocol
typealias GenericTableView_Protocol     = Designables.GenericTableView_Protocol
typealias AppFactory = Designables.Factory
typealias TopBar = Designables.V.TopBar
typealias BottomBar = Designables.V.BottomBar
typealias Sample_TableViewCell = Designables.V.Sample_TableViewCell
typealias UserTableViewCell = Designables.V.UserTableViewCell
typealias Sample_TableViewCellProtocol = Designables.Sample_TableViewCellProtocol

//MARK:- MISC

typealias CustomSearchBar = RJS_CustomSearchBar
