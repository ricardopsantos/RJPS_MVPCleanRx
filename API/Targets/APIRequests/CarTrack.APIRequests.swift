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

extension WebAPI.CarTrack {

    enum Target {
        case getUsers

        public var baseURL: String {
            return "https://jsonplaceholder.typicode.com"
        }

        public var endpoint: String {
            switch self {
            case .getUsers: return "\(baseURL)/users"
            }
        }

        public var httpMethod: String {
            switch self {
            case .getUsers: return "GET"
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
            let urlString = Target.getUsers.endpoint
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.getUsers.httpMethod
            responseType      = .json
            debugRequest      = DevTools.devModeIsEnabled
            returnOnMainTread = false
            if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                 mockedData = AppConstants.Mocks.GitHub.getUser_200
            }
        }
    }
}
