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
    class SampleA_UseCase : SampleA_UseCaseProtocol {
        
        func operation1(canUseCache: Bool, completionHandler: @escaping SampleA_UseCaseCompletionHandler) {
           // AppLogs.DLog(code: .notImplemented)
           // completionHandler(Result.failure(AppFactory.Errors.with(code: .notImplemented)))

            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                return
            }
            
            let repositoryNetwork = RN.Employees_NetworkRepository()
            var resultList : [E.Employee] = []
            
            let sequence = SequenceBlock()
            sequence.operation {
                repositoryNetwork.netWork_OperationB(completionHandler: { (result) in
                    switch result {
                    case .success(let some):
                        resultList = some.entity
                        sequence.success()
                        break
                    case .failure(let error):
                        completionHandler(Result.failure(error))
                        sequence.fail()
                        break
                    }
                })
                }.operation {
                    completionHandler(Result.success(resultList))
                    sequence.success()
                }
                .waitAll(onSuccess: {
                    let _ = 1
                }, onError: {
                    let _ = 1
                })
        }
        
        func operation2(param: String, completionHandler: @escaping SampleA_UseCaseCompletionHandler) {
            AppLogs.DLog(code: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(code: .notImplemented)))
        }
        
    }
}



