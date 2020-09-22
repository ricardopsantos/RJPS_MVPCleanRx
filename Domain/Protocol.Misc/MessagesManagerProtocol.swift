//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import AppConstants

public protocol MessagesManagerProtocol: AnyObject {
    func displayMessage(_ message: String, type: AlertType)
}
