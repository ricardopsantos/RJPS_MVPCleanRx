//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public struct Bliss {
    private init() {}
}

public extension Bliss {
    struct ServerHealth: Codable {
        public let status: String
    }
}

public extension Bliss.ServerHealth {
    var isOK: Bool { return status == "OK" }
}

public extension Bliss {
    struct ShareByEmail: Codable {
        public let status: String
    }
}

public extension Bliss.ShareByEmail {
    var sucess: Bool { return status == "OK" }
}

extension Bliss.Question: CustomStringConvertible {
    public var description: String {
        switch self {
        case .favouriteProgrammingLanguage: return "Favourite programming language?"
        }
    }
}
