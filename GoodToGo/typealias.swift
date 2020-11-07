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
import RJSLibUFBase
import RJSLibUFStorage
import RJSLibUFNetworking
import RJSLibUFAppThemes
//
import AppConstants
import AppTheme
import AppResources
import UIBase
import DevTools
import Designables

public typealias V = AppView
open class AppView { private init() {} }

public typealias VC = ViewController
public class ViewController { private init() {} }

public typealias VM = ViewModel
public struct ViewModel { private init() {} }

public typealias P = Presenter
public struct Presenter { private init() {} }

public typealias I = Interactor
public struct Interactor { private init() {} }

public typealias R = Router
public struct Router { private init() {} }

//
// MARK: - RJPSLib Shortcuts
//
// https://github.com/ricardopsantos/RJPSLib
// Turning the RJPSLib alias into something more readable and related to this app it self
//

typealias AppInfo                = RJS_AppInfo                        // Utilities for apps and device info. Things like `isSimulator`, `hasNotch`, etc
typealias AppUtils               = RJS_Utils                                    // Utilities like `onDebug`, `onRelease`, `executeOnce`, etc
typealias AppUserDefaultsVars    = RJS_UserDefaultsVars // NSUserDefaults utilities for Int Type
typealias AppUserDefaults        = RJS_UserDefaults               // NSUserDefaults utilities (save, delete, get, exits, ...)
typealias WebAPIRequestProtocol  = RJS_SimpleNetworkClientRequestProtocol
//typealias AppSimpleNetworkClient = RJPSLib_Networking.RJSLib.SimpleNetworkClient
