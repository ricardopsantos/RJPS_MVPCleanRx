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

let hummmm = "f9cc-014f-a76b-098f-9e82-f1c2-8837-9ea1".replace("-", with: "")
public extension API.GalleryAppAPIRequest {
    enum Target {
        case search

        public var baseURL: String {
            return "https://api.flickr.com/services/rest"
        }

        public var endpoint: String {
            switch self {
            case .search: return "\(baseURL)/?method=flickr.photos.search&api_key=\(hummmm)&tags=kitten&page=1&format=json&nojsoncallback=1"
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
            debugRequest      = DevTools.devModeIsEnabled
            returnOnMainTread = false
        }
    }
}
