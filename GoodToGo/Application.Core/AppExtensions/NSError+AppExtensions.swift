//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension NSError {
    
    struct AppKeys {
        static let userInfoDevMessageKey  = "Factory.Errors.userInfoDevMessageKey"
        static let userInfoViewMessageKey = "Factory.Errors.userInfoViewMessageKey"
        static let userInfoMoreInfoKey    = "Factory.Errors.moreInfo"
    }
    
    var localizableMessageForView : String {
        if let localizableMessageForView = self.userInfo[NSError.AppKeys.userInfoViewMessageKey] as? String {
            return localizableMessageForView
        }

        if let appCode = AppEnuns.AppCodes(rawValue: self.code) {
            return appCode.localizedMessageForView
        }
        return self.localizedDescription + (self.localizedRecoverySuggestion ?? "")
    }
}
