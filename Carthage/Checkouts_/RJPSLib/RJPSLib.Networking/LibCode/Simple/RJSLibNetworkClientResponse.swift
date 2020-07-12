//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

// This wraps a successful API response and it includes the generic data as well
// The reason why we need this wrapper is that we want to pass to the client the status code and the raw response as well

public enum RJSLibNetworkClientResponseType {
    case json
    case csv
}

public struct RJSLibNetworkClientResponse<T: Codable> {
    public let entity: T
    public let httpUrlResponse: HTTPURLResponse?
    public let data: Data?
    public let responseType: RJSLibNetworkClientResponseType
    public init(data: Data?, httpUrlResponse: HTTPURLResponse?, responseType: RJSLibNetworkClientResponseType) throws {
        do {
            switch responseType {
            case .json: self.entity = try JSONDecoder().decode(T.self, from: data!)
            case .csv : self.entity = try RJSLibNetworkClientResponse.parseCSV(data: data!)
            }
            self.httpUrlResponse = httpUrlResponse
            self.data            = data
            self.responseType    = responseType
        } catch {
            throw RJSLibNetworkClientErrorsManager.ClientError(error: error, httpUrlResponse: httpUrlResponse, data: data, reason: "")
        }
    }
    
    private static func parseCSV(data: Data) throws ->  T {
        let dataString: String! = String.init(data: data, encoding: .utf8)
        
        guard let jsonKeys: [String] = dataString.components(separatedBy: "\n").first?.components(separatedBy: ",") else {
            throw RJSLibNetworkClientErrorsManager.Custom.parseError
        }
        
        var parsedCSV: [[String: String]] = dataString
            .components(separatedBy: "\n")
            .map({
                var result = [String: String]()
                for (index, value) in $0.components(separatedBy: ",").enumerated() {
                    if index < jsonKeys.count {
                        result["\(jsonKeys[index])"] = value
                    }
                }
                return result
            })
        
        parsedCSV.removeFirst()
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parsedCSV, options: []) else {
            throw RJSLibNetworkClientErrorsManager.Custom.parseError
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
}
