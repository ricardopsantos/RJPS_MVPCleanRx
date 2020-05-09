//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension AppResources {
    private init() {}

    enum AppCodes: Int {
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

        //
        // For Dev Team
        //
        public var localisedMessageForDevTeam: String {
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
        public var localisedMessageForView: String {
            switch self {
            case .noInternet              : return AppResources.Messages.noInternet.localised
            case .invalidURL              : return AppResources.Messages.invalidURL.localised

            case .notImplemented          : return AppResources.Messages.pleaseTryAgainLater.localised
            case .notPredicted            : return AppResources.Messages.pleaseTryAgainLater.localised
            case .parsingError            : return AppResources.Messages.pleaseTryAgainLater.localised
            case .ignored                 : return AppResources.Messages.pleaseTryAgainLater.localised
            case .vmChanged               : return AppResources.Messages.pleaseTryAgainLater.localised
            case .dequeueReusableCellFail : return AppResources.Messages.pleaseTryAgainLater.localised
            case .unknownError            : return AppResources.Messages.pleaseTryAgainLater.localised
            case .referenceLost           : return AppResources.Messages.pleaseTryAgainLater.localised
            }
        }
    }

}
