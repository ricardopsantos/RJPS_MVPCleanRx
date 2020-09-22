//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Base
//
import DevTools
import Domain
//

public extension DevTools.Log {
    static func appCode(_ appCode: AppCodes, function: String = #function, file: String = #file, line: Int = #line) {
        guard enabled else { return }
        RJS_Logs.message(appCode.localisedMessageForDevTeam, function: function, file: file, line: line)
    }
}
