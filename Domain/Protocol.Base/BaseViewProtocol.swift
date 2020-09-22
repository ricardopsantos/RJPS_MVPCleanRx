//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import AppConstants

public protocol BaseViewControllerMVPProtocol: AnyObject {
    func setActivityState(_ state: Bool)
    func displayMessage(_ message: String, type: AlertType)
}
