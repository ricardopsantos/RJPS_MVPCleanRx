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
import Domain_Bliss
import DevTools

// MARK: - GetHealthStatus

public extension API.BlissAPIRequest {
    struct GetHealthStatus: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool = true
        public var debugRequest: Bool = DevTools.devModeIsEnabled
        public var urlRequest: URLRequest
        public var responseType: RJSLibNetworkClientResponseType
        public var mockedData: String? { "{\"status\": \"OK\"}" }

        init() throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/health"
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = RJS_NetworkClient.HttpMethod.get.rawValue
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}

// MARK: - ListQuestions

public extension API.BlissAPIRequest {
    struct ListQuestions: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool = true
        public var debugRequest: Bool = DevTools.devModeIsEnabled
        public var urlRequest: URLRequest
        public var responseType: RJSLibNetworkClientResponseType
        public var mockedData: String? { AppConstants.Mocks.Bliss.getQuestions_200 }

        init(limit: Int, filter: String, offSet: Int) throws {
            let escaped = filter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions?limit=\(limit)&offset=\(offSet)&escaped=\(escaped)"
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = RJS_NetworkClient.HttpMethod.get.rawValue
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}

// MARK: - QuestionById

public extension API.BlissAPIRequest {
    struct QuestionById: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool = true
        public var debugRequest: Bool = DevTools.devModeIsEnabled
        public var urlRequest: URLRequest
        public var responseType: RJSLibNetworkClientResponseType
        public var mockedData: String? { AppConstants.Mocks.Bliss.getQuestions_200 }

        init(id: Int) throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions/\(id)"
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = RJS_NetworkClient.HttpMethod.get.rawValue
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}

// MARK: - NewQuestion

extension API.BlissAPIRequest {
    struct NewQuestion: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: RJSLibNetworkClientResponseType
        var mockedData: String?

        init(question: Bliss.QuestionElementResponseDto) throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions"
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = RJS_NetworkClient.HttpMethod.post.rawValue
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameters: [String: Any] = [
                "question": question.question,
                "image_url": question.imageURL,
                "thumb_url": question.thumbURL,
                "choices": question.choices.map({ (some) -> String in
                    return "\(some.choice)"
                })
            ]
            urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}

// MARK: - UpdateQuestion

extension API.BlissAPIRequest {
    struct UpdateQuestion: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: RJSLibNetworkClientResponseType
        var mockedData: String?

        init(question: Bliss.QuestionElementResponseDto) throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions/\(question.id)"
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = RJS_NetworkClient.HttpMethod.put.rawValue
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameters: [String: Any] = [
                "question": question.question,
                "image_url": question.imageURL,
                "thumb_url": question.thumbURL,
                "choices": question.choices.map({ (some) -> String in
                    return "\(some.choice)"
                })
            ]
            urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}

// MARK: - Share

extension API.BlissAPIRequest {
    struct Share: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: RJSLibNetworkClientResponseType
        var mockedData: String?

        init(email: String, url: String) throws {
            let escapedURL = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/share?destination_email=\(email)&content_url=\(escapedURL)"
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = RJS_NetworkClient.HttpMethod.post.rawValue
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}
