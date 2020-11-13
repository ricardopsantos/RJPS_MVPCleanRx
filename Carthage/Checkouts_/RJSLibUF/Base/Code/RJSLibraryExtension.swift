//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

///////// GENERIC EXTENSIONS /////////

public struct RJSLibExtension<Target> {
    let target: Target
    init(_ target: Target) { self.target = target }
}

public protocol RJSLibExtensionCompatible { }

public extension RJSLibExtensionCompatible {
    var rjs: RJSLibExtension<Self> { return RJSLibExtension(self) }                   /* instance extension */
    static var rjs: RJSLibExtension<Self>.Type { return RJSLibExtension<Self>.self }  /* static extension */
}

extension NSObject: RJSLibExtensionCompatible { }

///////// LAYOUTS /////////
/*
public protocol RJPSLayoutsCompatible {
    associatedtype SomeType
    var rjsALayouts: SomeType { get }
}

public extension RJPSLayoutsCompatible {
    var rjsALayouts: RJPSLayouts<Self> { return RJPSLayouts(self) }
}

public struct RJPSLayouts<Target> {
    let target: Target
    init(_ target: Target) {
        self.target = target
    }
}

extension UIView: RJPSLayoutsCompatible {}
extension NSLayoutConstraint: RJPSLayoutsCompatible {}
*/
