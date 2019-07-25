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
    class Sample_UseCase : Sample_UseCaseProtocol {
        
        var generic_LocalStorageRepository : Generic_LocalStorageRepositoryProtocol!

        func operation1(canUseCache: Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                return
            }
            DispatchQueue.executeWithDelay (delay:1) {
                completionHandler(Result.success(["\(Date.utcNow())"]))
            }
        }
        
        func operation2(param: String, completionHandler: @escaping Sample_UseCaseCompletionHandler) {
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                return
            }
            DispatchQueue.executeWithDelay (delay:3) {
                completionHandler(Result.success(["\(Date.utcNow())"]))
            }
        }
        
    }
}



