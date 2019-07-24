//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

// This wraps a successful API response and it includes the generic data as well
// The reason why we need this wrapper is that we want to pass to the client the status code and the raw response as well

enum NetworkClientResponseType {
    case json
    case csv
}

struct NetworkClientResponse<T : Codable> {
    let entity          : T
    let httpUrlResponse : HTTPURLResponse
    let data            : Data?
    let responseType    : NetworkClientResponseType
    init(data: Data?, httpUrlResponse: HTTPURLResponse, responseType:NetworkClientResponseType) throws {
        do {
            switch responseType {
                case .json: self.entity = try JSONDecoder().decode(T.self, from: data!); break
                case .csv : self.entity = try NetworkClientResponse.parseCSV(data: data!); break
            }
            self.httpUrlResponse = httpUrlResponse
            self.data            = data
            self.responseType    = responseType
        } catch {
            throw NetworkClientErrorsManager.ClientError(error: error, httpUrlResponse: httpUrlResponse, data: data, reason: "")
        }
    }
    
    private static func parseCSV(data:Data) throws ->  T  {
          let dataString: String! = String.init(data: data, encoding: .utf8)
        
        guard let jsonKeys: [String] = dataString.components(separatedBy: "\n").first?.components(separatedBy: ",") else {
            throw NetworkClientErrorsManager.Custom.parseError
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
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parsedCSV, options: []) else{
            throw NetworkClientErrorsManager.Custom.parseError
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
}

