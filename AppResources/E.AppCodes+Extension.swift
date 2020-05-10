//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import AppDomain

public extension AppCodes {

    //
    // For Dev Team
    //
    var localisedMessageForDevTeam: String {
        switch self {
        case .noInternet              : return "Dev : No internet"
        case .invalidURL              : return "Dev : Invalid url"
        case .notImplemented          : return "Dev : Not implemented"
        case .notPredicted            : return "Dev : Not predicted"
        case .parsingError            : return "Dev : Parse error"
        case .ignored                 : return "Dev : Ignored"
        case .vmChanged               : return "Dev : ViewModel changed"
        case .dequeueReusableCellFail : return "Dev : dequeueReusableCellFail"
        case .unknownError            : return "Dev : Unknown error"
        case .referenceLost           : return "Dev : Reference lost"
        }
    }

    //
    // For end users
    //
    var localisedMessageForView: String {
        let defaultMessage = Messages.pleaseTryAgainLater.localised
        switch self {
        case .noInternet              : return Messages.noInternet.localised
        case .invalidURL              : return Messages.invalidURL.localised

        case .notImplemented          : return defaultMessage
        case .notPredicted            : return defaultMessage
        case .parsingError            : return defaultMessage
        case .ignored                 : return defaultMessage
        case .vmChanged               : return defaultMessage
        case .dequeueReusableCellFail : return defaultMessage
        case .unknownError            : return defaultMessage
        case .referenceLost           : return defaultMessage
        }
    }

}
