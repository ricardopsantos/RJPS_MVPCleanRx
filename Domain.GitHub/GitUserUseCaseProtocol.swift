//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//
import Domain

public typealias GitHubAPIRelated_S1_UseCaseCompletionHandler = (_ result: Result<GitHub.UserResponseDto>) -> Void
public typealias GitHubAPIRelated_S2_UseCaseCompletionHandler = (_ result: Result<[GitHub.UserResponseDto]>) -> Void

public protocol GitHubAPIRelated_UseCaseProtocol: class {

    func getInfoOfUserWith(userName: String,
                           canUseCache: Bool,
                           completionHandler: @escaping GitHubAPIRelated_S1_UseCaseCompletionHandler)

    func getFriendsOfUserWith(userName: String,
                              canUseCache: Bool,
                              completionHandler: @escaping GitHubAPIRelated_S2_UseCaseCompletionHandler)
}
