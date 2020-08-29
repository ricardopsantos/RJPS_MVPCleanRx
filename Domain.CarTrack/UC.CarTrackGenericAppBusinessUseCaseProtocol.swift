//
//  GoodToGo
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Networking
//

/**
Use case Protocol for things related with app generic business
 */

public protocol CarTrackGenericAppBusinessUseCaseProtocol: class {
    func validate(user: String, password: String, completionHandler: @escaping (_ result: Result<Bool>) -> ())
}
