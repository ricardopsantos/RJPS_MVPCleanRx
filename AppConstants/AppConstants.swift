//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib

public struct AppConstants {
    private init() {}

    public static let defaultAnimationsTime = RJS_Constants.defaultAnimationsTime
    
    public struct Rx {
        // https://medium.com/fantageek/throttle-vs-debounce-in-rxswift-86f8b303d5d4
        // Throttle : Will ignore events between the time span of xxxx miliseconds
        // Debounce : Only "fire" event, after the last happen after xxxx miliseconds.... Good to avoid double taps
        //static let tappingDefaultThrottle    = 10
        public static let tappingDefaultDebounce    = 500

        public static let servicesDefaultThrottle   = 10
        public static let servicesDefaultDebounce   = 250
        
        public static let textFieldsDefaultDebounce = 1000
        //static let textFieldsDefaultThrottle = 10

    }

    public struct URLs {
        private init() {}
        public static let useMockedData = true
        public static var githubAPIBaseUrl: String {
            return "https://api.github.com"
//            switch AppEnvironments.current {
//            case .dev  : return "https://api.github.com"
//            case .prod : return "https://api.github.com"
//            case .qa   : return "https://api.github.com"
//            }
        }
       
        public static let getPostCodes = "https://github.com/centraldedados/codigos_postais/raw/master/data/codigos_postais.csv"
        public static let getEmployees = "http://dummy.restapiexample.com/api/v1/employees"
    }
    
    public struct Cache {
        public static let serverRequestCacheLifeSpam: Int = 5 // minutes
        public static let servicesCache: String = "servicesCache"
    }
    
    public struct Dev {
        private init() {}
        public static let tapDefaultDisableTime: Double = 2
        public static let cellIdentifier      = "DefaultCell"
        public static let keyCoreDataLastUser = "keyCoreDataLastUser"

        public static let keyCoreDataSaveLang = "keyCoreDataSaveLang"
        public static let numberOfLogins      = "numberOfLogins"
        public static let mainStoryBoard      = "Main"
    }    
}
