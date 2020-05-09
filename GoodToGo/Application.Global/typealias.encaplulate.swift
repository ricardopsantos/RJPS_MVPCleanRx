//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Models

typealias M = Model
struct Model { private init() {} }

typealias E = Entity 
struct Entity { private init() {} }

// MARK: - Scenes

typealias V = AppView
struct AppView { private init() {} }

typealias VC = ViewController
struct ViewController { private init() {} }

typealias VM = ViewModel
struct ViewModel { private init() {} }

typealias P = Presenter
struct Presenter { private init() {} }

typealias I = Interactor
struct Interactor { private init() {} }

typealias R = Router
struct Router { private init() {} }

// MARK: - DDD & Clean

typealias RP = Repository
struct Repository { private init() {} }

typealias UC = UseCases
class UseCases { private init() {} }

typealias MP = Mappers
struct Mappers { private init() {} }

// MARK: - Utils

typealias AS = AssembyContainer
struct AssembyContainer { private init() {} }

struct AppManagers { private init() {} }

typealias Enuns = AppEnuns
struct AppEnuns { private init() {} }
