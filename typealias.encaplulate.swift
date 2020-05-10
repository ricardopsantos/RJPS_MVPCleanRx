//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// Common to all frameworks

// MARK: - Models

public typealias M = Model
public struct Model { private init() {} }

//public typealias E = Entity
//public struct Entity { }

// MARK: - Scenes

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
