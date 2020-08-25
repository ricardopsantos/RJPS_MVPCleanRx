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

public typealias CarTrackGenericAppBusinessUseCaseCompletionHandler = (_ result: Result<Bool>) -> ()

public protocol CarTrackGenericAppBusiness_UseCaseProtocol: class {
    func validate(user: String, password: String, completionHandler: @escaping CarTrackGenericAppBusinessUseCaseCompletionHandler)
}
