//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

public typealias GitUser_Single_UseCaseCompletionHandler = (_ result: Result<GitHub.UserResponseDto>) -> Void
public typealias GitUser_Friends_UseCaseCompletionHandler = (_ result: Result<[GitHub.UserResponseDto]>) -> Void

public protocol GitUserUseCaseProtocol: class {
    func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_UseCaseCompletionHandler)
    func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_UseCaseCompletionHandler)
}
