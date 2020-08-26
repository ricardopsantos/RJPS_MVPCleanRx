//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RJPSLib_Base
import RxSwift
import RxCocoa
import RJPSLib_Networking
//
import AppConstants
import PointFreeFunctions
import Domain
import Domain_GalleryApp
import DevTools

// MARK: - Target

public extension API.GalleryAppAPIRequest {
    enum Target {
        case search

        public var baseURL: String {
            return "https://api.flickr.com/services/rest"
        }

        public var key: String {
            "DTBfK2jeRNQ3ABo9l+elSOK9hYeMkKhoTt6f9L43aU7iq+Y7rId+k4TSJDIVNZy6LNaL2uHVkyVy2CEC".aesDecrypt()
        }

        public var endpoint: String {
            switch self {
            case .search: return "\(baseURL)/?method=flickr.photos.search&api_key=\(key)&tags=kitten&page=1&format=json&nojsoncallback=1"
            }
        }

        public var httpMethod: String {
            switch self {
            case .search: return RJS_SimpleNetworkClient.HttpMethod.get.rawValue
            }
        }
    }
}

// MARK: - GetUserInfo

public extension API.GalleryAppAPIRequest {
    struct SearchRequest {
        let tags: [String]
    }
    struct Search: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool
        public var urlRequest: URLRequest
        public var responseType: RJS_SimpleNetworkClientResponseType
        public var mockedData: String? { return DevTools.FeatureFlag.devTeam_useMockedData.isTrue ? AppConstants.Mocks.GalleryApp.search_200 : nil }

        init(request: SearchRequest) throws {
            let urlString = Target.search.endpoint
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.search.httpMethod
            responseType      = .json
            debugRequest      = false//DevTools.devModeIsEnabled
            returnOnMainTread = true
        }
    }
}
