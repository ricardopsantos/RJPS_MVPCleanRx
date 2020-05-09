//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

extension Entity {
    struct Bliss {
        private init() {}
    }
}

extension Entity.Bliss {
    struct ServerHealth: Codable {
        let status: String
    }
}

extension E.Bliss.ServerHealth {
    var isOK: Bool { return status == "OK" }
}

extension E.Bliss {
    struct ShareByEmail: Codable {
        let status: String
    }
}

extension E.Bliss.ShareByEmail {
    var sucess: Bool { return status == "OK" }
}

extension E.Bliss.Question: CustomStringConvertible {
    var description: String {
        switch self {
        case .favouriteProgrammingLanguage: return "Favourite programming language?"
        }
    }
}
