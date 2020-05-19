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

public extension API.Bliss {
    struct GetHealthStatus_APIRequest: WebAPIRequest_Protocol {
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

public extension API.Bliss {
    struct ListQuestions_APIRequest: WebAPIRequest_Protocol {
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

public extension API.Bliss {
    struct QuestionById_APIRequest: WebAPIRequest_Protocol {
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

extension API.Bliss {
    struct NewQuestion_APIRequest: WebAPIRequest_Protocol {
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
            urlRequest.httpMethod = "POST"
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

extension API.Bliss {
    struct UpdateQuestion_APIRequest: WebAPIRequest_Protocol {
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
            urlRequest.httpMethod = "PUT"
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameters: [String: Any] = [
                "question": question.question,
                "image_url": question.imageURL,
                "thumb_url": question.thumbURL,
                "choices": question.choices.map({ (some) -> String in
                    return "\(some.choice)"
                })
            ]
            //if AppCan.Logs.requests {
            //    DevTools.Log.log("\(parameters)")
            //}
            urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}

extension API.Bliss {
    struct Share_APIRequest: WebAPIRequest_Protocol {
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
            urlRequest.httpMethod = "POST"
            responseType = .json
        }
        
        static let maxNumberOfRetrys = 3
    }
}
