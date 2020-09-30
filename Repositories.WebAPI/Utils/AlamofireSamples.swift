//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import Alamofire
//
import DevTools

struct TestAlamofireLogin: Encodable {
    let email: String
    let password: String
}

public class AlamofireTesting {

    public static func doTests() {
        let url = "https://httpbin.org/get"

        if false {
            // Sample 1: Basic GET 1
            AF.request(url).response { response in
                debugPrint(response)
            }
        }

        if false {
            // Sample 2: Basic GET 2
            AF.request(url) { urlRequest in
                urlRequest.timeoutInterval = 5
            }.response { response in
                debugPrint(response)
            }
        }

        let login = TestAlamofireLogin(email: "test@test.test", password: "testPassword")

        if false {
            // Sample 3: Basic POST with parameters
            AF.request("https://httpbin.org/post",
                       method: .post,
                       parameters: login,
                       encoder: JSONParameterEncoder.default).response { response in
                        debugPrint(response)
            }
        }

        // Sample 4: Now its good...
        AF.request(SampleAlamofireAPIRequestable.someGet).response { response in
            debugPrint(response)
        }

        AF.request(SampleAlamofireAPIRequestable.somePostWithParameters(login)).response { response in
            debugPrint(response)
        }
    }

}

enum SampleAlamofireAPIRequestable: URLRequestConvertible {

    // 1 : Declare constants to hold the Imagga base URL and your Basic xxx with your actual authorization header.
    enum Constants {
        static let baseURLPath = "https://httpbin.org"
        static let authenticationToken = "Basic xxx"
    }

    // 2 : Declare the enum cases. Each case corresponds to an api endpoint.
    case someGet
    case somePostWithParameters(TestAlamofireLogin)

    // 3 : Return the HTTP method for each api endpoint.
    var method: HTTPMethod {
        switch self {
        case .someGet: return .get
        case .somePostWithParameters: return .post
        }
    }

    // 4 : Return the path for each api endpoint.
    var path: String {
        switch self {
        case .someGet:
            return "/get"
        case .somePostWithParameters:
            return "/post"
        }
    }

    // 5 : Return the parameters for each api endpoint.
    var parameters: [String: Any] {
        switch self {
        case .someGet:
            return [:]
        case .somePostWithParameters(let parameters):
            return ["email": parameters.email, "password": parameters.password]
        }
    }

    // 6 : Use all of the above components to create a URLRequest for the requested endpoint.
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
