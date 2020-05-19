//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import DevTools

public extension Mappers {
    
    static func listFromCSV<T: Decodable>(_ dataString: String) -> [T] {
        do {
            guard let jsonKeys: [String] = dataString.components(separatedBy: "\n").first?.components(separatedBy: ",") else {
                DevTools.Log.error("Parsing error")
                return []
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
                DevTools.Log.error("Parsing error")
                return []
            }
            return try JSONDecoder().decode([T].self, from: jsonData)
        } catch let error {
            DevTools.Log.error(error)
        }
        return []
    }

}
