//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

protocol Generic_CacheRepositoryProtocol {
    func add(object:AnyObject, withKey:String) -> Void
    func get(key:String) -> AnyObject?
    func clean(sender: String) -> Void
}
