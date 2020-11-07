//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJSLibUFStorage

// MARK: - DevTools

//public typealias CacheStrategy = RJSLibUFStorage.RJSLib.Storages.CachePersistant.CacheStrategy


#warning("fix this")
public enum CacheStrategy {
    case cacheNoLoad    // Use cache only
    case noCacheLoad    // Cache ignored, and returns latest available value
    case cacheElseLoad  // Will use cache if available, else returns latest available value (good because avoids server calls)
    case cacheAndLoad   // Can emit twice, one for cache (if available) and other with the latest available value

    public var canUseCache: Bool {
        return self != .noCacheLoad
    }
}

