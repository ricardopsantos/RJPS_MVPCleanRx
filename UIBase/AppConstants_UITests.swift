//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

// Constants that are shared (existing) in the the app's and UI TESTS

public enum AppConstants_UITests {
    
    public struct Misc {
        public struct CommandLineArguments {
            public static let deleteUserData = "--uitesting_CommandLineArguments.deleteUserData"
        }
        public static let devOptionAlertTitle = "Dev options"
    }
    
    public struct UIViewControllers {
        private init() {}
        private static let accessibilityIdentifierPrefix = "acId"
        public static func genericAccessibilityIdentifier(_ controller: GenericView) -> String {
            return "\(accessibilityIdentifierPrefix).\(controller.className)"
        }
    }
}
