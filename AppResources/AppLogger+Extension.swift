//
//  AppLogger+Extension.swift
//  AppResources
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib
//
import DevTools
//

public extension AppLogger {
    static func log(appCode: AppCodes, function: String = #function, file: String = #file, line: Int = #line) {
        guard enabled else { return }
        RJS_Logs.DLog(appCode.localizedMessageForDevTeam, function: function, file: file, line: line)
    }
}
