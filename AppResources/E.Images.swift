//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

 public enum Images: String {
    case notFound
    case noInternet

    struct TopBar {
        private init() {}
        public static let background: UIImage = UIImage()
    }

    public var image: UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }
}
