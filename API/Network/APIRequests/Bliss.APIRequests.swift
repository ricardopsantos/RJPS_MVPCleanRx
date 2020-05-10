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

extension Network.Bliss {
    struct GetHealthStatus_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init() throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/health"
            if let url = URL(string: "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/health") {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType = .json
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData =
                    """
                    {
                    "status": "OK"
                    }
                    """
                }
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}

extension Network.Bliss {
    struct ListQuestions_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(limit: Int, filter: String, offSet: Int) throws {
            let escaped = filter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions?limit=\(limit)&offset=\(offSet)&escaped=\(escaped)"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType = .json
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData = AppConstants.Mocks.Bliss.getQuestions_200
                }
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}

extension Network.Bliss {
    struct QuestionById_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(id: Int) throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions/\(id)"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType = .json
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData = AppConstants.Mocks.Bliss.getQuestions_200
                }
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}

extension Network.Bliss {
    struct NewQuestion_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(question: Bliss.QuestionElementResponseDto) throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions"
            if let url = URL(string: "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions") {
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
                //if AppCan.Logs.requests {
                //    AppLogger.log("\(parameters)")
                //}
                urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
                responseType = .json
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}

extension Network.Bliss {
    struct UpdateQuestion_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(question: Bliss.QuestionElementResponseDto) throws {
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/questions/\(question.id)"
            if let url = URL(string: urlString) {
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
                //    AppLogger.log("\(parameters)")
                //}
                urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
                responseType = .json
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}

extension Network.Bliss {
    struct Share_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool = true
        var debugRequest: Bool = DevTools.devModeIsEnabled
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(email: String, url: String) throws {
            let escapedURL = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let urlString = "\(AppConstants.Bliss.URLs.blissAPIBaseUrl)/share?destination_email=\(email)&content_url=\(escapedURL)"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                responseType = .json
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}
