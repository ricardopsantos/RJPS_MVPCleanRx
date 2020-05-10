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

public extension WebAPI.Employees {
    struct GetEmployees_APIRequest: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool = true
        public var debugRequest: Bool = DevTools.devModeIsEnabled
        public var urlRequest: URLRequest
        public var responseType: NetworkClientResponseType
        public var mockedData: String?

        public init() throws {
            let urlString = AppConstants.URLs.getEmployees
            if let url = URL(string: AppConstants.URLs.getEmployees) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType = .json
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData = AppConstants.Mocks.Employees.getEmployees_200
                }
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
        
        public static let maxNumberOfRetrys = 3
    }
}
