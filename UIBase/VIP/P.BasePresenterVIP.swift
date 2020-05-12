//
//  BasePresenterVIP.swift
//  UIBase
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import DevTools

open class BasePresenterVIP: BasePresenterVIPProtocol {
    public init () {}
    open weak var baseViewController: BaseViewControllerVIPProtocol? {
        fatalError("Override me on pressenter")
    }
    deinit {
        //AppLogger.log("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }
}
