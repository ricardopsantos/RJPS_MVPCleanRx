//
//  Created by Ricardo Santos on 05/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

extension VisionBox {
    public enum Category: Int, CaseIterable {
        case cat1 = 10000
        case cat2
        case cat3
        case cat4
        case cat5
        case cat6
        case cat7
        case cat8
        case cat9

        public var tag: Int { return self.rawValue }

        public var toString: String {
            switch self {
            case .cat1: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat2: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat3: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat4: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat5: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat6: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat7: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat8: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            case .cat9: return imageName.capitalized.replacingOccurrences(of: ".", with: " ")
            }
        }

        public var imageName: String {
            switch self {
            case .cat1: return "message"
            case .cat2: return "bag"
            case .cat3: return "cart"
            case .cat4: return "heart"
            case .cat5: return "bed.double"
            case .cat6: return "skew"
            case .cat7: return "car"
            case .cat8: return "tv"
            case .cat9: return "envelope"
            }
        }
    }
}
