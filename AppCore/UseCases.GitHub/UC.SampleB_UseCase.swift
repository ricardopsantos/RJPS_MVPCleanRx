//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib
import Domain
import Factory

//public extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
extension UC {
    public class SampleB_UseCase: GenericUseCase, SampleB_UseCaseProtocol {
       public override init() { super.init() }

           public var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
           public var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!

       public func operation1(canUseCache: Bool, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
               AppLogger.log(appCode: .notImplemented)
               completionHandler(Result.failure(Factory.Errors.with(appCode: .notImplemented)))
           }

       public func operation2(param: String, completionHandler: @escaping SampleB_UseCaseCompletionHandler) {
               AppLogger.log(appCode: .notImplemented)
               completionHandler(Result.failure(Factory.Errors.with(appCode: .notImplemented)))
           }

       }
}

//}
