//
//  GenericViewProtocol.swift
//  AppDomain
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import AppConstants

public protocol BaseViewControllerMVPProtocol: AnyObject {
    func setActivityState(_ state: Bool)
    func displayMessage(_ message: String, type: AlertType)
    func setNoConnectionViewVisibility(to: Bool, withMessage: String)
}
