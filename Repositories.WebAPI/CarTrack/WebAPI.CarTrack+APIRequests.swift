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
import RJSLibUFNetworking
//
import AppConstants
import PointFreeFunctions
import Domain
import DevTools
import Domain_CarTrack

// MARK: - Target

public extension WebAPI.CarTrackAPIRequest {
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
            case .getUsers: return RJS_SimpleNetworkClient.HttpMethod.get.rawValue
            }
        }
    }
}

// MARK: - GetUserInfo

public extension WebAPI.CarTrackAPIRequest {
    struct GetUsers: WebAPIRequestProtocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool = DevTools.FeatureFlag.debugRequests.isTrue
        public var urlRequest: URLRequest
        public var responseType: RJS_SimpleNetworkClientResponseType

        // service has bad data. use mock value always
        public var mockedData: String? { return WebAPI.useMock || true  ? AppConstants.Mocks.CarTrack.get_200 : nil }

        init(request: CarTrackRequests.GetUsers) throws {
            let urlString = Target.getUsers.endpoint
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.getUsers.httpMethod
            responseType      = .json
            returnOnMainTread = false
        }
    }
}
