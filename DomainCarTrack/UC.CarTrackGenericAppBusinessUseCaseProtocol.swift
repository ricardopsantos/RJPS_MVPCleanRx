//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJSLibUFNetworking
//

/**
Use case Protocol for things related with app generic business
 */

public protocol CarTrackGenericAppBusinessUseCaseProtocol: class {
    func validate(user: String, password: String, completionHandler: @escaping (_ result: Result<Bool>) -> ())
}
