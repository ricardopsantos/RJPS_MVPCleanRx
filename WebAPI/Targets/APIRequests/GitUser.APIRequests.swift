//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain
import DevTools

public extension API.GitUser {

    enum Target {
        case getUser(userName: String)
        case getFriends(userName: String)

        var baseURL: String {
            return "https://api.github.com"
        }

        var endpoint: String {
            switch self {
            case .getUser(userName: let userName): return "\(baseURL)/users/\(userName)"
            case .getFriends(userName: let userName): return "\(baseURL)/users/\(userName)/followers"
            }
        }

        var httpMethod: String {
            switch self {
            case .getUser   : return RJS_NetworkClient.HttpMethod.get.rawValue
            case .getFriends: return RJS_NetworkClient.HttpMethod.get.rawValue
            }
        }
    }
}

public extension API.GitUser {

    struct GetUserInfo_APIRequest: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool
        public var urlRequest: URLRequest
        public var responseType: RJSLibNetworkClientResponseType
        public var mockedData: String? { return DevTools.FeatureFlag.devTeam_useMockedData.isTrue ? AppConstants.Mocks.GitHub.getUser_200 : nil }

        init(userName: String) throws {
            let urlString = Target.getUser(userName: userName).endpoint
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.getUser(userName: userName).httpMethod
            responseType      = .json
            debugRequest      = DevTools.devModeIsEnabled
            returnOnMainTread = false
        }
    }
}

public extension API.GitUser {
    struct GetFriends_APIRequest: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool
        public var urlRequest: URLRequest
        public var responseType: RJSLibNetworkClientResponseType
        public var mockedData: String? { return DevTools.FeatureFlag.devTeam_useMockedData.isTrue ? AppConstants.Mocks.GitHub.getUser_200 : nil }

        init(userName: String) throws {
            let urlString = Target.getFriends(userName: userName).endpoint
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.getFriends(userName: userName).httpMethod
            responseType      = .json
            debugRequest      = DevTools.devModeIsEnabled
            returnOnMainTread = false
        }
    }
}
