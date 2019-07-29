//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

/**
 Encapsulate all Entity
 */

typealias E = Entity
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
 Encapsulate all AppsViews
 */

typealias V = AppView
struct AppView { private init() {} }

/**
 Encapsulate all Repositories
 */
typealias RP = Repository
struct Repository {
    private init() {}
}

/**
 Encapsulate all Routers
 */
typealias R = Router
struct Router { private init() {} }

/**
 Encapsulate all UserCases
 */
typealias UC = UseCases
class UseCases  { private init() {} }


typealias MP = Mappers
struct Mappers { private init() {} }

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
