//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib

struct AppConstants {
    private init() {}

    static let defaultAnimationsTime = RJS_Constants.defaultAnimationsTime
    
    struct Rx {
        // https://medium.com/fantageek/throttle-vs-debounce-in-rxswift-86f8b303d5d4
        // Throttle : Will ignore events between the time span of xxxx miliseconds
        // Debounce : Only "fire" event, after the last happen after xxxx miliseconds.... Good to avoid double taps
        static let tappingDefaultThrottle    = 10
        static let tappingDefaultDebounce    = 500 

        static let servicesDefaultThrottle   = 10
        static let servicesDefaultDebounce   = 250
        
        static let textFieldsDefaultDebounce = 1000
        static let textFieldsDefaultThrottle = 10

    }

    struct URLs {
        private init() {}
        static var githubAPIBaseUrl : String {
            switch AppEnvironments.current {
            case .dev  : return "https://api.github.com"
            case .prod : return "https://api.github.com"
            case .qa   : return "https://api.github.com"
            }
        }
       
        static let getPostCodes = "https://github.com/centraldedados/codigos_postais/raw/master/data/codigos_postais.csv"
        static let getEmployees = "http://dummy.restapiexample.com/api/v1/employees"
    }
    
    struct Dev {
        private init() {}
        static let cellIdentifier      = "DefaultCell"
        static let keyCoreDataLastUser = "keyCoreDataLastUser"
        static let keyCoreDataSaveLang = "keyCoreDataSaveLang"
        static let numberOfLogins      = "numberOfLogins"
        static let mainStoryBoard      = "Main"
        static let referenceLost       = "referenceLost"
    }
    
}

