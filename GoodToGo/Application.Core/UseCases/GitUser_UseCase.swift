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
    
    class GitUser_UseCase : GitUser_UseCaseProtocol {
        
        func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_UseCaseCompletionHandler) {
            
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            RN.GitUser_NetWorkRepository().getInfoOfUserWith(userName: userName, canUseCache: true, completionHandler: { result in
                switch result {
               case .success(let some):
                    let user : E.GitHubUser = some.entity
                    completionHandler(Result.success(user))
                    break
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    break
                }
            })
        }
        
        func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_UseCaseCompletionHandler) {
            
            guard RJS_Utils.existsInternetConnection() else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            RN.GitUser_NetWorkRepository().getFriendsOfUserWith(userName: userName, canUseCache: true, completionHandler: { (result) in
                switch result {
                case .success(let some):
                    let friends : [E.GitHubUser] = some.entity
                    completionHandler(Result.success(friends))
                    break
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    break
                }
            })
        }
    }
    
}




