//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension RJSLib {
    
    static var version: String { return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)! }
    
    struct Constants {
        private init() {}
        public static let defaultDelay: Double = 0.3
        public static let defaultAnimationsTime: Double = 0.3
        public static let defaultDisableTimeAfterTap: Double = 1 // Time span in which the view will be disabled after some user interaction
        public struct Tags {
            public static let progressView = 18530186
        }
        private static let _sharedLibConstantsId: String = "RJSLib.Constants."
        public static let notPredicted: String = "\(_sharedLibConstantsId)notPredicted"
        public static let fail: String = "\(_sharedLibConstantsId)fail"
        public static let referenceLost: String = "\(_sharedLibConstantsId)referenceLost"
        public static let userInterationDisabled: String = "\(_sharedLibConstantsId)userInterationDisabled"
    }
}
