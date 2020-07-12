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

public extension API.CarTrackAPIRequest {
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
            case .getUsers: return RJS_NetworkClient.HttpMethod.get.rawValue
            }
        }
    }
}

// MARK: - GetUserInfo

public extension API.CarTrackAPIRequest {
    struct GetUserInfo: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool
        public var urlRequest: URLRequest
        public var responseType: RJSLibNetworkClientResponseType
        public var mockedData: String? { return DevTools.FeatureFlag.devTeam_useMockedData.isTrue ? AppConstants.Mocks.CarTrack.get_200 : nil }

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
        }
    }
}
