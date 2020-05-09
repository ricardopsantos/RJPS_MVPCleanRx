//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// Commom to all frameworks

// MARK: - Models

public typealias M = Model
public struct Model { private init() {} }

public typealias E = Entity
public struct Entity { private init() {} }

// MARK: - Scenes

public typealias V = AppView
public struct AppView { private init() {} }

public typealias VC = ViewController
public struct ViewController { private init() {} }

public typealias VM = ViewModel
public struct ViewModel { private init() {} }

public typealias P = Presenter
public struct Presenter { private init() {} }

public typealias I = Interactor
public struct Interactor { private init() {} }

public typealias R = Router
public struct Router { private init() {} }

// MARK: - DDD & Clean

public typealias RP = Repository
public struct Repository { private init() {} }

public typealias UC = UseCases
public class UseCases { private init() {} }

public typealias MP = Mappers
public struct Mappers { private init() {} }

// MARK: - Utils

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

public struct AppManagers { private init() {} }
