//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
    class SampleB_UseCase : SampleB_UseCaseProtocol {
        
        func operation1(canUseCache: Bool, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
            AppLogs.DLog(code: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(code: .notImplemented)))
        }
        
        func operation2(param: String, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
            AppLogs.DLog(code: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(code: .notImplemented)))
        }
        
    }
}



