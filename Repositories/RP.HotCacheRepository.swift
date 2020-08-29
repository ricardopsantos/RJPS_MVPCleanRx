//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Storage
//
import UIKit
import AVFoundation
import Domain

public extension RP {
    class HotCacheRepository: HotCacheRepositoryProtocol {
        public init () {}
        public func add(object: AnyObject, withKey: String) {
            RJS_LiveCache.shared.add(object: object, withKey: withKey)
        }
        public func get(key: String) -> AnyObject? {
            return RJS_LiveCache.shared.get(key: key)
        }
        public func clean(sender: String) {
            RJS_LiveCache.shared.clean()
        }
    }
}
