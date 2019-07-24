//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

extension Repository.Network {
    struct GetEmployees_APIRequest : WebAPIRequest_Protocol {
        var returnOnMainTread : Bool = true
        var debugRequest      : Bool = AppCan.Logs.requests
        var urlRequest        : URLRequest
        var responseType      : NetworkClientResponseType
        var mockedData        : String? = nil

        init() throws {
            if let url = URL(string: AppConstants.URLs.getEmployees) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType = .json
            }
            else {
                throw AppFactory.Errors.with(code: .invalidURL)
            }
        }
        
        static let maxNumberOfRetrys = 3
    }
}

