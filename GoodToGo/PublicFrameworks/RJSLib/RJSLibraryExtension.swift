//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

///////// GENERIC EXTENSIONS /////////

struct RJSLibExtension<Target> {
    let target: Target
    init(_ target: Target) { self.target = target }
}

protocol RJSLibExtensionCompatible { }

extension RJSLibExtensionCompatible {
    var rjs: RJSLibExtension<Self>             { return RJSLibExtension(self) }       /* instance extension */
    static var rjs: RJSLibExtension<Self>.Type { return RJSLibExtension<Self>.self }  /* static extension */
}

extension NSObject: RJSLibExtensionCompatible { }

///////// LAYOUTS /////////

public protocol RJPSLayoutsCompatible {
    associatedtype someType
    var rjsALayouts: someType { get }
}

public extension RJPSLayoutsCompatible {
    public var rjsALayouts: RJPSLayouts<Self> { get { return RJPSLayouts(self) } }
}

public struct RJPSLayouts<Target> {
    let target: Target
    init(_ target: Target) {
        self.target = target
    }
}

extension UIView: RJPSLayoutsCompatible {}
