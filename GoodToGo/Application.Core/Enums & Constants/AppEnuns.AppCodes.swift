//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

extension AppEnuns {
    private init() {}
    
    enum AppCodes : Int {
        case noInternet = 1000
        case notImplemented
        case notPredicted
        case parsingError
        case ignored
        case invalidURL
        case vmChanged
        case dequeueReusableCellFail
        case unknownError
        case referenceLost

        var localizableString : String {
            switch self {
            case .noInternet              : return AppMessages.noInternet
            case .notImplemented          : return "Dev : Not implemented"
            case .notPredicted            : return "Dev : Not predicted"
            case .parsingError            : return "Dev : Parse error"
            case .ignored                 : return "Dev : Ignored"
            case .vmChanged               : return "Dev : ViewModel changed"
            case .dequeueReusableCellFail : return "Dev : Ignored"
            case .invalidURL              : return AppMessages.invalidURL
            case .unknownError            : return "Dev : Unknow error"
            case .referenceLost           : return "Dev : Reference lost"
            }
        }
    }    
}

