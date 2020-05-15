//
//  FactoryErrors.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import Domain
import AppResources

public extension AppCodes {

    func makeErrorWith(code: AppCodes) -> Error {
        return code.toError
    }
    
    var toError: Error {
        return Factory.Errors.with(appCode: self)
    }
}

public struct Factory {
    private init() {}

    public struct Errors {
        private init() {}
        public static func with(appCode: AppCodes, info: String="") -> Error {
            let domain: String = "\(Bundle.main.bundleIdentifier!)"
            let code: Int = appCode.rawValue
            var userInfo: [String: Any] = [:]
            userInfo["userInfo.appCode"]        = "\(appCode.rawValue)"
            userInfo["userInfo.dev.localised"]  = appCode.localisedMessageForDevTeam
            userInfo["userInfo.prod.localised"] = appCode.localisedMessageForView
            userInfo["extra.prod.info"]         = appCode.localisedMessageForView
            return NSError(domain: domain, code: code, userInfo: userInfo)
        }
    }
}

// Error to AppCode!
public extension Error {

    var localisedMessageForView: String {
        if let appCode = self.appCode {
            return appCode.localisedMessageForView
        }
        return Messages.defaultErrorMessage
    }

    var appCode: AppCodes? {
        if let nsError = self as? NSError { return nsError.appCode }
        return AppCodes.unknownError
    }
}

// NSError to AppCode!
public extension NSError {
    var appCode: AppCodes? {
        if let appCodeString = self.userInfo["userInfo.appCode"] {
            if let appCode = AppCodes(rawValue: Int("\(appCodeString)") ?? -1) {
                return appCode
            }
        }
        return AppCodes.unknownError
    }
}
