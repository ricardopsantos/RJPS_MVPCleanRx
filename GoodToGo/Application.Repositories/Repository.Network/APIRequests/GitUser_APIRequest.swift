//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

extension Repository.Network {
    struct GetUserInfo_APIRequest : WebAPIRequest_Protocol {
        var returnOnMainTread : Bool
        var debugRequest      : Bool
        var urlRequest        : URLRequest
        var responseType      : NetworkClientResponseType
        var mockedData        : String? = nil

        init(userName:String) throws {
            if let url = URL(string: "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)") {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = AppCan.Logs.requests
                returnOnMainTread = false
            }
            else {
                throw AppFactory.Errors.with(code: .invalidURL)
            }
        }
    }
    struct GetFriends_APIRequest : WebAPIRequest_Protocol {
        var returnOnMainTread : Bool
        var debugRequest      : Bool
        var urlRequest        : URLRequest
        var responseType      : NetworkClientResponseType
        var mockedData        : String? = nil

        init(userName:String) throws {
            if let url = URL(string: "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)/followers") {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = AppCan.Logs.requests
                returnOnMainTread = false
            }
            else {
                throw AppFactory.Errors.with(code: .invalidURL)
            }
        }
    }
}


