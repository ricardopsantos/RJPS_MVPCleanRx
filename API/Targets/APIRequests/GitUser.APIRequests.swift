//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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

extension WebAPI.GitUser {

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
            case .getUser: return "GET"
            case .getFriends: return "GET"
            }
        }
    }

    struct GetUserInfo_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool
        var debugRequest: Bool
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

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
            if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                 mockedData = AppConstants.Mocks.GitHub.getUser_200
            }
        }
    }

    struct GetFriends_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool
        var debugRequest: Bool
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String? 

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
            if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                mockedData = AppConstants.Mocks.GitHub.getUser_200
            }
        }
    }
}
