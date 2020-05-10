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
import AppDomain
import DevTools

extension WebAPI.GitUser {
    struct GetUserInfo_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool
        var debugRequest: Bool
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(userName: String) throws {
            let urlString = "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = DevTools.devModeIsEnabled
                returnOnMainTread = false
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                     mockedData = AppConstants.Mocks.GitHub.getUser_200
                }
            } else { throw APIErrors.invalidURL(url: urlString) }
        }
    }
    struct GetFriends_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool
        var debugRequest: Bool
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String? 

        init(userName: String) throws {
            let urlString = "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)/followers"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = DevTools.devModeIsEnabled
                returnOnMainTread = false
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData = AppConstants.Mocks.GitHub.getUser_200
                }
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
    }
}
