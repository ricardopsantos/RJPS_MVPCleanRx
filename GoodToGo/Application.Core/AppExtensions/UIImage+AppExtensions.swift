//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    struct App {
        private init() {}
        struct TopBar {
            private init() {}
            static let background: UIImage = UIImage()
        }
        static let notFound: UIImage = UIImage(named: "notFound") ?? UIImage()
        static let notInternet: UIImage = UIImage(named: "notInternet") ?? UIImage()
    }
}
