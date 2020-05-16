//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public struct Designables {
    public struct Sizes {
        private init() {}
        
        public struct Apple {
            private init() {}
            public static var safeAreaTop: CGFloat = 44
            public static var safeAreaBottom: CGFloat = 34
            public static var tabBarControllerDefaultSize: CGFloat = 60
        }
        
        public struct Margins {
            private init() {}
            public static var defaultMargin: CGFloat = 16
        }
        
        public struct Button {
            private init() {}
            public static var defaultSize: CGSize { return CGSize(width: 125, height: 50) }
        }
        
        public struct Misc {
            private init() {}
            public static let defaultMargin: CGFloat = 25
        }
        
        public struct TableView {
            private init() {}
            public static let defaultHeightForHeaderInSection: CGFloat = 25
        }
        
        public struct TableViewCell {
            private init() {}
            public static let defaultSize: CGFloat = 40
        }
        
    }
}
