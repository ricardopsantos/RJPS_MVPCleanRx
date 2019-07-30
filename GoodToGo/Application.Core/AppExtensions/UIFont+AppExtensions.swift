//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension UIFont {
    struct App {
        private init() {}
        enum Size : CGFloat {
            case big        = 15
            case regularBig = 13.5
            case regular    = 12
            case small      = 10
        }
        
        static let bold    = AppFonts.bold(size: .regular)
        static let regular = AppFonts.regular(size: .regular)
        static let light   = AppFonts.light(size: .regular)
        static func bold(size: AppFonts.Size)    -> UIFont { return UIFont(name: "HelveticaNeue-Medium", size: size.rawValue)! }
        static func regular(size: AppFonts.Size) -> UIFont { return UIFont(name: "HelveticaNeue", size: size.rawValue)! }
        static func light(size: AppFonts.Size)   -> UIFont { return UIFont(name: "HelveticaNeue-Thin", size: size.rawValue)! }
    }
}
