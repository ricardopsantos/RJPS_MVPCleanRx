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
import RJPSLib_Networking
//
import AppConstants
import PointFreeFunctions
import Domain
import DevTools

// MARK: - Target

public extension API.GitHubAPIRequest {

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
            case .getUser   : return RJS_SimpleNetworkClient.HttpMethod.get.rawValue
            case .getFriends: return RJS_SimpleNetworkClient.HttpMethod.get.rawValue
            }
        }
    }
}

// MARK: - GetUserInfo

public extension API.GitHubAPIRequest {

    struct GetUserInfo: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool
        public var urlRequest: URLRequest
        public var responseType: RJS_SimpleNetworkClientResponseType
        //public var mockedData: String? { return DevTools.FeatureFlag.devTeam_useMockedData.isTrue ? AppConstants.Mocks.GitHub.getUser_200 : nil }
        public var mockedData: String? { return AppConstants.Mocks.GitHub.getUser_200 }

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

// MARK: - GetFriends

public extension API.GitHubAPIRequest {
    struct GetFriends: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool
        public var urlRequest: URLRequest
        public var responseType: RJS_SimpleNetworkClientResponseType
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
