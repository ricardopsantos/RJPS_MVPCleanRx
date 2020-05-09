//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension AppManagers {
    
    struct Layouts {
        private init() {}
        
        struct Button {
            private init() {}
            static var defaultSize: CGSize { return CGSize(width: 125, height: 40) }
        }
        struct Misc {
            private init() {}
            static let defaultMargin: CGFloat = 25
        }
        
    }
}
