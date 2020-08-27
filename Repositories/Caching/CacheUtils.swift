//
//  Created by Ricardo Santos on 27/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public struct CacheUtils {
    public static func composedKey(_ key: String, _ keyParams: [String]) -> String {
        if keyParams.count > 0 {
            return "\(key)_\(parseKeyParams(keyParams))"
        } else {
            return "\(key)"
        }
    }

    public static func parseKeyParams(_ params: [String]) -> String {
        return "[" + params.joined(separator: ",") + "]"
    }
}
