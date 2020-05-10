//
//  FactoryErrors.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import Domain

public struct ErrorsFactory {
    private init() {}

    public static func with(appCode: AppCodes, info: String="") -> Error {
        let domain: String = "\(Bundle.main.bundleIdentifier!)"
        let code: Int = appCode.rawValue
        var userInfo: [String: Any] = [:]
        userInfo["userInfo.dev"]  = appCode.localisedMessageForDevTeam
        userInfo["userInfo.prod"] = appCode.localisedMessageForView
        userInfo["extra.prod"]    = appCode.localisedMessageForView
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
