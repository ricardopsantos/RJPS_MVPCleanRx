//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib

extension AppConstants {
    private init() {}
    
    struct Bliss {
        static let useMockedData = false
        static let logoURL : String = "https://static.itjobs.pt/images/companies/57/1d3/1475/logo.png?btfc=1498121844" //"https://media.licdn.com/dms/image/C560BAQF48lgMCIY3FA/company-logo_200_200/0?e=2159024400&v=beta&t=OD27mw1uDClWEJLmtz7wU8TFg9Hod2Yd1p1Wx6Zl0Eo"

        struct URLs {
            static var blissAPIBaseUrl : String {
                switch AppEnvironments.current {
                case .dev  : return "https://private-anon-f659e751cc-blissrecruitmentapi.apiary-mock.com"
                case .prod : return "https://private-anon-f659e751cc-blissrecruitmentapi.apiary-mock.com"
                case .qa   : return "https://private-anon-f659e751cc-blissrecruitmentapi.apiary-mock.com"
                }
            }
        }
        
        struct DeepLinks {
            static let questionsFilter = "question_filter" // DONT CHANGE VALUE
            static let questionId      = "question_id"     // DONT CHANGE VALUE
        }
    }
   
}

