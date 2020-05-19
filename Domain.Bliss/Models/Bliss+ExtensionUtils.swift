//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import Domain

public struct Bliss {
    private init() {}
}

public extension Bliss {
    struct ServerHealth: ModelEntityProtocol {
        public let status: String
    }
}

public extension Bliss.ServerHealth {
    var isOK: Bool { return status == "OK" }
}

public extension Bliss {
    struct ShareByEmail: ModelEntityProtocol {
        public let status: String
    }
}

public extension Bliss.ShareByEmail {
    var success: Bool { return status == "OK" }
}

extension Bliss.Question: CustomStringConvertible {
    public var description: String {
        switch self {
        case .favouriteProgrammingLanguage: return "Favourite programming language?"
        }
    }
}
