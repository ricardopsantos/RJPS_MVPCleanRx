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

// MARK: - RJPSLib Shortcuts

typealias AppInfo                = RJS_AppInfo
typealias AppCoreDataManager     = RJS_DataModel
typealias AppSimpleNetworkClient = RJS_SimpleNetworkClient
typealias AppUtils               = RJS_Utils
//typealias AppCache               = RJS_CacheLive
//typealias AppFileSystem          = RJS_Files
typealias AppUserDefaultsVars    = RJS_UserDefaultsVars
typealias AppUserDefaults        = RJS_UserDefaults
typealias WebAPIRequest_Protocol = RJSLibWebAPIRequest_Protocol

// MARK: - App Shortcuts

typealias AppColors              = UIColor.App
typealias AppFonts               = UIFont.App
typealias AppProtocols           = RootAssemblyContainerProtocols

// MARK: - DevTools

typealias AppLogger   = DevTools.AppLogger

// MARK: - GenericView

//typealias GenericView = UIBase.BaseViewControllerMVP

// MARK: - MISC

typealias InputFields = RJS_Designables_InputFields
