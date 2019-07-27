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
    class BlissQuestionsAPI_UseCase : BlissQuestionsAPI_UseCaseProtocol {

        var repositoryNetwork : Bliss_NetWorkRepositoryProtocol!
        
        private func serverIsOK(completionHandler:@escaping (Bool)->()) -> Void {
            getHealth { (some) in
                switch some {
                case .success(let some): completionHandler(some.isOK)
                case .failure(_): completionHandler(false)
                }
            }
        }
        
        func getHealth(completionHandler: @escaping (Result<E.Bliss.ServerHealth>) -> Void) {
         
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                return
            }
            
            repositoryNetwork.getHealth { (result) in
                switch result {
                case .success(let some):
                    completionHandler(Result.success(some.entity))
                    break
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    break
                }
            }

        }
        
        func shareQuestionBy(email: String, url: String, checkHealth:Bool, completionHandler: @escaping (Result<E.Bliss.ShareByEmail>) -> Void) {
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
                strongSelf.repositoryNetwork.shareQuestionBy(email: email, url: url, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity)); break
                    case .failure(let error): completionHandler(Result.failure(error)); break
                    }
                })
            }
            if(!checkHealth) {
                guard RJS_Utils.existsInternetConnection() else {
                    completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                    return
                }
                doWork()
            }
            else {
                serverIsOK { (ok) in
                    if(ok) { doWork() }
                    else { completionHandler(Result.failure(AppFactory.Errors.with(code: .notPredicted))) }
                }
            }
        }
        

        func updateQuestion(question: E.Bliss.QuestionElement, checkHealth: Bool, completionHandler: @escaping (Result<E.Bliss.QuestionElement>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
                strongSelf.repositoryNetwork.updateQuestion(question: question, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity)); break
                    case .failure(let error): completionHandler(Result.failure(error)); break
                    }
                })
            }
            if(!checkHealth) {
                guard RJS_Utils.existsInternetConnection() else {
                    completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                    return
                }
                doWork()
            }
            else {
                serverIsOK { (ok) in
                    if(ok) { doWork() }
                    else { completionHandler(Result.failure(AppFactory.Errors.with(code: .notPredicted))) }
                }
            }
        }
        
        func getQuestions(limit: Int, filter: String, offSet: Int, checkHealth:Bool=true, completionHandler: @escaping (Result<[E.Bliss.QuestionElement]>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
                strongSelf.repositoryNetwork.getQuestions(limit: limit, filter: filter, offSet: offSet, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity)); break
                    case .failure(let error): completionHandler(Result.failure(error)); break
                    }
                })
            }
            
            if(!checkHealth) {
                guard RJS_Utils.existsInternetConnection() else {
                    completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                    return
                }
                doWork()
            }
            else {
                serverIsOK { (ok) in
                    if(ok) { doWork() }
                    else { completionHandler(Result.failure(AppFactory.Errors.with(code: .notPredicted))) }
                }
            }
        
        }
        
        func getQuestionBy(id: Int, checkHealth:Bool=true, completionHandler: @escaping (Result<E.Bliss.QuestionElement>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
                strongSelf.repositoryNetwork.getQuestionBy(id: id, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity)); break
                    case .failure(let error): completionHandler(Result.failure(error)); break
                    }
                })
            }
            
            if(!checkHealth) {
                guard RJS_Utils.existsInternetConnection() else {
                    completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                    return
                }
                doWork()
            }
            else {
                serverIsOK { (ok) in
                    if(ok) { doWork() }
                    else { completionHandler(Result.failure(AppFactory.Errors.with(code: .notPredicted))) }
                }
            }
        }
        
        func makeQuestion(question: E.Bliss.QuestionElement, checkHealth:Bool=true, completionHandler: @escaping (Result<E.Bliss.QuestionElement>) -> Void) {
            
            let doWork = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(code: AppEnuns.AppCodes.referenceLost); return }
                strongSelf.repositoryNetwork.makeQuestion(question: question, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity)); break
                    case .failure(let error): completionHandler(Result.failure(error)); break
                    }
                })
            }
            if(!checkHealth) {
                guard RJS_Utils.existsInternetConnection() else {
                    completionHandler(Result.failure(AppFactory.Errors.with(code: .noInternet)))
                    return
                }
                doWork()
            }
            else {
                serverIsOK { (ok) in
                    if(ok) { doWork() }
                    else { completionHandler(Result.failure(AppFactory.Errors.with(code: .notPredicted))) }
                }
            }
        }
    }
}



