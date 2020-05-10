//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib
import AppDomain

//public extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
 public class SampleB_UseCase: GenericUseCase, SampleB_UseCaseProtocol {

        var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
        var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!
        
    public func operation1(canUseCache: Bool, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
            AppLogger.log(appCode: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notImplemented)))
        }
        
    public func operation2(param: String, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
            AppLogger.log(appCode: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notImplemented)))
        }
        
    }
//}
