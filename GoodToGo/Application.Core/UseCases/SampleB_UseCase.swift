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
    class SampleB_UseCase : GenericUseCase, SampleB_UseCaseProtocol {

        var generic_CacheRepositoryProtocol : Generic_CacheRepositoryProtocol!
        var generic_LocalStorageRepository  : Generic_LocalStorageRepositoryProtocol!
        
        func operation1(canUseCache: Bool, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
            AppLogs.DLog(appCode: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notImplemented)))
        }
        
        func operation2(param: String, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
            AppLogs.DLog(appCode: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notImplemented)))
        }
        
    }
}
