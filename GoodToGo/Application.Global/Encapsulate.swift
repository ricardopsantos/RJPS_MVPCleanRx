//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//////////////////////// MVVM STUFF ONLY ////////////////////////
//////////////////////// MVVM STUFF ONLY ////////////////////////
//////////////////////// MVVM STUFF ONLY ////////////////////////

typealias M = Model
struct Model { private init() {} }

typealias VC = ViewController
struct ViewController { private init() {} }

//////////////////////// MVP STUFF ONLY ////////////////////////
//////////////////////// MVP STUFF ONLY ////////////////////////
//////////////////////// MVP STUFF ONLY ////////////////////////

/**
 Encapsulate all Entity
 */

typealias E = Entity // Same as Model in MVP
struct Entity { private init() {} }

/**
 Encapsulate all Views ViewModel
 */
typealias VM = ViewModel
struct ViewModel { private init() {} }

/**
 Encapsulate all Presenters
 */
typealias P = Presenter
struct Presenter { private init() {} }

/**
 Encapsulate all AppsViews (ViewControllers)
 */

typealias V = AppView
struct AppView { private init() {} }

//////////////////////// CLEAN STUFF ONLY ////////////////////////
//////////////////////// CLEAN STUFF ONLY ////////////////////////
//////////////////////// CLEAN STUFF ONLY ////////////////////////

typealias RP = Repository
struct Repository { private init() {} }

typealias R = Router
struct Router { private init() {} }

typealias UC = UseCases
class UseCases  { private init() {} }

typealias MP = Mappers
struct Mappers { private init() {} }

//////////////////////// UTILS STUFF ONLY ////////////////////////
//////////////////////// UTILS STUFF ONLY ////////////////////////
//////////////////////// UTILS STUFF ONLY ////////////////////////

/**
 Encapsulate AssembyContainers
 */

typealias AS = AssembyContainer
struct AssembyContainer { private init() {} }

/**
 Encapsulate Managers
 */

struct AppManagers { private init() {} }

/**
 Encapsulate Enuns
 */
typealias Enuns = AppEnuns
struct AppEnuns { private init() {} }
