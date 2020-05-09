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

typealias GitUser_Single_NetWorkRepositoryCompletionHandler = (_ result: Result<NetworkClientResponse<GitHubUserResponseDto>>) -> Void
typealias GitUser_Friends_NetWorkRepositoryCompletionHandler = (_ result: Result<NetworkClientResponse<[GitHubUserResponseDto]>>) -> Void
protocol GitUser_NetWorkRepositoryProtocol: class {
    func getInfoOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Single_NetWorkRepositoryCompletionHandler)
    func getFriendsOfUserWith(userName: String, canUseCache: Bool, completionHandler: @escaping GitUser_Friends_NetWorkRepositoryCompletionHandler)
}
