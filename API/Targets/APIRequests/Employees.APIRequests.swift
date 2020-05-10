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

    enum Target {
        case getEmployees

        public var baseURL: String {
            return "http://dummy.restapiexample.com/api/v1"
        }

        public var endpoint: String {
            switch self {
            case .getEmployees: return "\(baseURL)/employees"
            }
        }

        public var httpMethod: String {
            switch self {
            case .getEmployees: return "GET"
            }
        }
    }

    struct GetEmployees_APIRequest: WebAPIRequest_Protocol {
        public var returnOnMainTread: Bool = true
        public var debugRequest: Bool = DevTools.devModeIsEnabled
        public var urlRequest: URLRequest
        public var responseType: NetworkClientResponseType
        public var mockedData: String?

        public init() throws {
            let urlString = Target.getEmployees.endpoint
            guard let url = URL(string: urlString) else {
                throw APIErrors.invalidURL(url: urlString)
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Target.getEmployees.httpMethod
            responseType = .json
            if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                mockedData = AppConstants.Mocks.Employees.getEmployees_200
            }
        }
        
        public static let maxNumberOfRetrys = 3
    }
}
