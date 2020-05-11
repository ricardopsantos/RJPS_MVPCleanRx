//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public struct LayoutsSizes {
    private init() {}

    struct Button {
        private init() {}
        public static var defaultSize: CGSize { return CGSize(width: 125, height: 40) }
    }
    struct Misc {
        private init() {}
        public static let defaultMargin: CGFloat = 25
    }

}
