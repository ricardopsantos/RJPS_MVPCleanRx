//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension AppManagers {
    
    struct Ressources {
        private init() {}

        static func get(_ code:String) -> String { return code }
        static var selectedLanguage : SelectedLanguage = .en {
            didSet{ AppGlobal.saveWith(key: AppConstants.Dev.keyCoreDataSaveLang, value: "\(selectedLanguage)") }
        }
        enum SelectedLanguage: Int { case en, pt }
        
        struct Messages {
            private init() {}
            static let noInternet          = "Please check your internet connection"
            static let pleaseTryAgainLater = "Please try again latter"
            static let dismiss             = "Dismiss"
            static let alert               = "Alert"
            static let ok                  = "OK"
            static let sucess              = "Sucess"
            static let no                  = "NO"
            static let details             = "Details"
            static let invalidURL          = "Invalid URL"
        }
    }
}




