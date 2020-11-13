//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension Array {
    var randomItem: Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

public extension Array where Element: Hashable {
    /// Taken from here: https://stackoverflow.com/a/46354989/491239
    static func removeDuplicates(_ elements: [Element]) -> [Element] {
        var seen = Set<Element>()
        return elements.filter { seen.insert($0).inserted }
    }
}
