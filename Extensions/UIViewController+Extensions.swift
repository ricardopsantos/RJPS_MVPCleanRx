//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift

public extension UIViewController {

    var genericAccessibilityIdentifier: String {
        // One day we will have Accessibility on the app, and we will be ready....
        let name = String(describing: type(of: self))
        return "accessibilityIdentifierPrefix.\(name)"
    }
}
