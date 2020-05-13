//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

public extension UIFont {
    struct App {
        private init() {}
        public enum Size: CGFloat {
            case big        = 24 // Heading
            case regularBig = 18 // Paragraph
            case regular    = 12 // caption
            case small      = 10
        }
        
        public static let bold    = Self.bold(size: .regular)
        public static let regular = Self.regular(size: .regular)
        public static let light   = Self.light(size: .regular)

        public static func bold(size: Size) -> UIFont {
            return UIFont(name: "HelveticaNeue-Medium", size: size.rawValue)!
        }

        public static func regular(size: Size) -> UIFont {
            return UIFont(name: "HelveticaNeue", size: size.rawValue)!
        }

        public static func light(size: Size) -> UIFont {
            return UIFont(name: "HelveticaNeue-Thin", size: size.rawValue)!
        }
    }
}
