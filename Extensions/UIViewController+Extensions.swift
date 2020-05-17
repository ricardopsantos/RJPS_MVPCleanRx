//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

public extension UIViewController {

    var genericAccessibilityIdentifier: String {
        // One day we will have Accessibility on the app, and we will be ready....
        let name = String(describing: type(of: self))
        return "accessibilityIdentifierPrefix.\(name)"
    }

    func dismissMe(animated: Bool=true) {
        let navigationController = self.navigationController != nil
        if !navigationController {
            self.dismiss(animated: animated, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: animated)
        }
    }
}
