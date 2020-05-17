//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
import UIKit
import AVFoundation
import Domain

#warning("old cache")
public extension RP {
    class CacheRepository: CacheRepositoryProtocol {

        public init () {}

        public func add(object: AnyObject, withKey: String) {
            RJS_CacheLive.add(object: object, withKey: withKey)
        }

        public func get(key: String) -> AnyObject? {
            return RJS_CacheLive.get(key: key)
        }

        public func clean(sender: String) {
            RJS_CacheLive.clean(sender: sender)
        }
    }
}
