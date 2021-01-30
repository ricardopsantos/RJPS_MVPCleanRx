//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RJSLibUFNetworking
//
import BaseConstants
import DevTools
import BaseRepositoryWebAPI
import DomainGalleryApp

// MARK: - Target

public extension WebAPI.GalleryAppAPIRequest {
    enum Target {
        case search
        case imageInfo

        public var baseURL: String {
            return "https://api.flickr.com/services/rest"
        }

        private var key: String { ProcessInfo.processInfo.environment["FLICK_KEY"] ?? "not_found" }

        public var endpoint: String {
            switch self {
            case .search: return "\(baseURL)/?method=flickr.photos.search&api_key=\(key)&format=json&nojsoncallback=1"
            case .imageInfo: return "\(baseURL)/?method=flickr.photos.getSizes&api_key=\(key)&format=json&nojsoncallback=1"
            }
        }

        public var httpMethod: String {
            switch self {
            case .search: return RJS_HttpMethod.get.rawValue
            case .imageInfo: return RJS_HttpMethod.get.rawValue
            }
        }
    }
}

// MARK: - Search

public extension WebAPI.GalleryAppAPIRequest {

    struct Search: WebAPIRequestProtocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool = DevTools.FeatureFlag.debugRequests.isTrue
        public var urlRequest: URLRequest
        public var responseType: RJS_NetworkClientResponseFormat
        public var mockedData: String? { return WebAPI.useMock ? AppConstants.Mocks.GalleryApp.search_200 : nil }

        init(request: GalleryAppRequests.Search) throws {
            let urlString = Target.search.endpoint + request.urlEscaped
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.search.httpMethod
            responseType      = .json
            returnOnMainTread = true
        }
    }

}

// MARK: - ImageInfo

public extension WebAPI.GalleryAppAPIRequest {

    struct ImageInfo: WebAPIRequestProtocol {
        public var returnOnMainTread: Bool
        public var debugRequest: Bool = DevTools.FeatureFlag.debugRequests.isTrue
        public var urlRequest: URLRequest
        public var responseType: RJS_NetworkClientResponseFormat
        public var mockedData: String? { return WebAPI.useMock ? AppConstants.Mocks.GalleryApp.imageInfo_200 : nil }

        init(request: GalleryAppRequests.ImageInfo) throws {
            let urlString = Target.imageInfo.endpoint + request.urlEscaped
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.search.httpMethod
            responseType      = .json
            returnOnMainTread = true
        }
    }
}
