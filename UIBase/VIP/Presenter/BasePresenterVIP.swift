//
//  BasePresenterVIP.swift
//  UIBase
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

open class BasePresenterVIP: BasePresentationLogicProtocol {
    open var baseDisplayLogic: BaseDisplayLogicProtocol? {
        assert(false)
        return nil
    }
    deinit {
        AppLogger.log("\(self) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    public init () {}
}
