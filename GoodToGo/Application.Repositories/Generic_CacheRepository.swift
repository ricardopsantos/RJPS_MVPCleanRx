//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
import UIKit
import AVFoundation

extension RP {
    struct Cache {
        
    }
}

extension RP.Cache {
    class Generic_CacheRepository: Generic_CacheRepositoryProtocol {
        func add(object: AnyObject, withKey: String) { RJS_Cache.add(object: object, withKey: withKey) }
        func get(key: String) -> AnyObject?          { return RJS_Cache.get(key: key) }
        func clean(sender: String)                   { RJS_Cache.clean(sender:sender) }
    }
}

