//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

// Constants that are shared (existing) in the the app's and UI TESTS

public enum AppConstants_UITests {
    
    struct Misc {
        struct CommandLineArguments {
            static let deleteUserData = "--uitesting_CommandLineArguments.deleteUserData"
        }
        static let devOptionAlertTitle = "Dev options"
    }
    
    struct UIViewControllers {
        private init() {}
        private static let accessibilityIdentifierPrefix = "acId"
        static func genericAccessibilityIdentifier(_ controller: GenericView) -> String {
            return "\(accessibilityIdentifierPrefix).\(controller.className)"
        }
    }
}
