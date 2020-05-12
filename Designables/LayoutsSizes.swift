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

    public struct Margins {
        private init() {}
        public static var defaultMarginH: CGFloat = 24
    }

    public struct Button {
        private init() {}
        public static var defaultSize: CGSize { return CGSize(width: 125, height: 40) }
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
