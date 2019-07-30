//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

extension RP.Network.GitUser {
    struct GetUserInfo_APIRequest : WebAPIRequest_Protocol {
        var returnOnMainTread : Bool
        var debugRequest      : Bool
        var urlRequest        : URLRequest
        var responseType      : NetworkClientResponseType
        var mockedData        : String?

        init(userName:String) throws {
            if let url = URL(string: "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)") {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = AppCan.Logs.requests
                returnOnMainTread = false
                if AppConstants.URLs.useMockedData {
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
            }
            else {
                throw AppFactory.Errors.with(appCode: .invalidURL)
            }
        }
    }
    struct GetFriends_APIRequest : WebAPIRequest_Protocol {
        var returnOnMainTread : Bool
        var debugRequest      : Bool
        var urlRequest        : URLRequest
        var responseType      : NetworkClientResponseType
        var mockedData        : String? 

        init(userName:String) throws {
            if let url = URL(string: "\(AppConstants.URLs.githubAPIBaseUrl)/users/\(userName)/followers") {
                urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                responseType      = .json
                debugRequest      = AppCan.Logs.requests
                returnOnMainTread = false
                if AppConstants.URLs.useMockedData {
                    mockedData = """
                    [{"login":"cabaco88","id":4489878,"node_id":"MDQ6VXNlcjQ0ODk4Nzg=","avatar_url":"https://avatars2.githubusercontent.com/u/4489878?v=4","gravatar_id":"","url":"https://api.github.com/users/cabaco88","html_url":"https://github.com/cabaco88","followers_url":"https://api.github.com/users/cabaco88/followers","following_url":"https://api.github.com/users/cabaco88/following{/other_user}","gists_url":"https://api.github.com/users/cabaco88/gists{/gist_id}","starred_url":"https://api.github.com/users/cabaco88/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/cabaco88/subscriptions","organizations_url":"https://api.github.com/users/cabaco88/orgs","repos_url":"https://api.github.com/users/cabaco88/repos","events_url":"https://api.github.com/users/cabaco88/events{/privacy}","received_events_url":"https://api.github.com/users/cabaco88/received_events","type":"User","site_admin":false},{"login":"renatorodrigues","id":246079,"node_id":"MDQ6VXNlcjI0NjA3OQ==","avatar_url":"https://avatars0.githubusercontent.com/u/246079?v=4","gravatar_id":"","url":"https://api.github.com/users/renatorodrigues","html_url":"https://github.com/renatorodrigues","followers_url":"https://api.github.com/users/renatorodrigues/followers","following_url":"https://api.github.com/users/renatorodrigues/following{/other_user}","gists_url":"https://api.github.com/users/renatorodrigues/gists{/gist_id}","starred_url":"https://api.github.com/users/renatorodrigues/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/renatorodrigues/subscriptions","organizations_url":"https://api.github.com/users/renatorodrigues/orgs","repos_url":"https://api.github.com/users/renatorodrigues/repos","events_url":"https://api.github.com/users/renatorodrigues/events{/privacy}","received_events_url":"https://api.github.com/users/renatorodrigues/received_events","type":"User","site_admin":false},{"login":"RicardoBarroso","id":2791179,"node_id":"MDQ6VXNlcjI3OTExNzk=","avatar_url":"https://avatars3.githubusercontent.com/u/2791179?v=4","gravatar_id":"","url":"https://api.github.com/users/RicardoBarroso","html_url":"https://github.com/RicardoBarroso","followers_url":"https://api.github.com/users/RicardoBarroso/followers","following_url":"https://api.github.com/users/RicardoBarroso/following{/other_user}","gists_url":"https://api.github.com/users/RicardoBarroso/gists{/gist_id}","starred_url":"https://api.github.com/users/RicardoBarroso/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/RicardoBarroso/subscriptions","organizations_url":"https://api.github.com/users/RicardoBarroso/orgs","repos_url":"https://api.github.com/users/RicardoBarroso/repos","events_url":"https://api.github.com/users/RicardoBarroso/events{/privacy}","received_events_url":"https://api.github.com/users/RicardoBarroso/received_events","type":"User","site_admin":false},{"login":"AndiChiou","id":23460812,"node_id":"MDQ6VXNlcjIzNDYwODEy","avatar_url":"https://avatars0.githubusercontent.com/u/23460812?v=4","gravatar_id":"","url":"https://api.github.com/users/AndiChiou","html_url":"https://github.com/AndiChiou","followers_url":"https://api.github.com/users/AndiChiou/followers","following_url":"https://api.github.com/users/AndiChiou/following{/other_user}","gists_url":"https://api.github.com/users/AndiChiou/gists{/gist_id}","starred_url":"https://api.github.com/users/AndiChiou/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/AndiChiou/subscriptions","organizations_url":"https://api.github.com/users/AndiChiou/orgs","repos_url":"https://api.github.com/users/AndiChiou/repos","events_url":"https://api.github.com/users/AndiChiou/events{/privacy}","received_events_url":"https://api.github.com/users/AndiChiou/received_events","type":"User","site_admin":false}]
                    """
                }
            } else {
                throw AppFactory.Errors.with(appCode: .invalidURL)
            }
        }
    }
}
