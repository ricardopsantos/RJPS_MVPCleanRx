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
    class BlissQuestionsAPI_UseCase : GenericUseCase, BlissQuestionsAPI_UseCaseProtocol {

        var repositoryNetwork               : Bliss_NetWorkRepositoryProtocol!
        var generic_CacheRepositoryProtocol : Generic_CacheRepositoryProtocol!
        var generic_LocalStorageRepository  : Generic_LocalStorageRepositoryProtocol!
        
        private func serverIsOK(completionHandler:@escaping (Bool)->Void) {
            getHealth { (some) in
                switch some {
                case .success(let some): completionHandler(some.isOK)
                case .failure          : completionHandler(false)
                }
            }
        }
        
        func getHealth(completionHandler: @escaping (Result<E.Bliss.ServerHealth>) -> Void) {
         
            guard existsInternetConnection else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            repositoryNetwork.getHealth { (result) in
                switch result {
                case .success(let some) : completionHandler(Result.success(some.entity))
                case .failure(let error):completionHandler(Result.failure(error))
                }
            }

        }
        
        func shareQuestionBy(email: String, url: String, checkHealth:Bool, completionHandler: @escaping (Result<E.Bliss.ShareByEmail>) -> Void) {
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.repositoryNetwork.shareQuestionBy(email: email, url: url, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
        
        func updateQuestion(question: E.Bliss.QuestionElement, checkHealth: Bool, completionHandler: @escaping (Result<E.Bliss.QuestionElement>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.repositoryNetwork.updateQuestion(question: question, completionHandler: { (result) in
                    switch result {
                    case .success(let some) : completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
        
        func getQuestions(limit: Int, filter: String, offSet: Int, checkHealth:Bool=true, completionHandler: @escaping (Result<[E.Bliss.QuestionElement]>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.repositoryNetwork.getQuestions(limit: limit, filter: filter, offSet: offSet, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        
        }
        
        func getQuestionBy(id: Int, checkHealth:Bool=true, completionHandler: @escaping (Result<E.Bliss.QuestionElement>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.repositoryNetwork.getQuestionBy(id: id, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
        
        func makeQuestion(question: E.Bliss.QuestionElement, checkHealth:Bool=true, completionHandler: @escaping (Result<E.Bliss.QuestionElement>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.repositoryNetwork.makeQuestion(question: question, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
    }
}
