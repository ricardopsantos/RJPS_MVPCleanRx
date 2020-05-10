//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import DevTools

// swiftlint:disable line_length

extension Network.GitUser {
    struct GetUserInfo_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool
        var debugRequest: Bool
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String?

        init(userName: String) throws {
            let urlString = "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = DevTools.devModeIsEnabled
                returnOnMainTread = false
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData = """
                    {
                    "login": "ricardopsantos",
                    "id": 932236,
                    "node_id": "MDQ6VXNlcjkzMjIzNg==",
                    "avatar_url": "https://avatars2.githubusercontent.com/u/932236?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/ricardopsantos",
                    "html_url": "https://github.com/ricardopsantos",
                    "followers_url": "https://api.github.com/users/ricardopsantos/followers",
                    "following_url": "https://api.github.com/users/ricardopsantos/following{/other_user}",
                    "gists_url": "https://api.github.com/users/ricardopsantos/gists{/gist_id}",
                    "starred_url": "https://api.github.com/users/ricardopsantos/starred{/owner}{/repo}",
                    "subscriptions_url": "https://api.github.com/users/ricardopsantos/subscriptions",
                    "organizations_url": "https://api.github.com/users/ricardopsantos/orgs",
                    "repos_url": "https://api.github.com/users/ricardopsantos/repos",
                    "events_url": "https://api.github.com/users/ricardopsantos/events{/privacy}",
                    "received_events_url": "https://api.github.com/users/ricardopsantos/received_events",
                    "type": "User",
                    "site_admin": false,
                    "name": "Ricardo Santos",
                    "company": null,
                    "blog": "https://www.linkedin.com/profile/view?id=76568046",
                    "location": "Lisbon (Portugal)",
                    "email": null,
                    "hireable": true,
                    "bio": null,
                    "public_repos": 6,
                    "public_gists": 2,
                    "followers": 4,
                    "following": 6,
                    "created_at": "2011-07-22T10:17:02Z",
                    "updated_at": "2019-07-24T10:28:53Z"
                    }
                    """
                }
            } else { throw APIErrors.invalidURL(url: urlString) }
        }
    }
    struct GetFriends_APIRequest: WebAPIRequest_Protocol {
        var returnOnMainTread: Bool
        var debugRequest: Bool
        var urlRequest: URLRequest
        var responseType: NetworkClientResponseType
        var mockedData: String? 

        init(userName: String) throws {
            let urlString = "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)/followers"
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = DevTools.devModeIsEnabled
                returnOnMainTread = false
                if DevTools.FeatureFlag.getFlag(.devTeam_useMockedData) {
                    mockedData = AppConstants.Mocks.GitHub.getUser_200
                }
            } else {
                throw APIErrors.invalidURL(url: urlString)
            }
        }
    }
}
