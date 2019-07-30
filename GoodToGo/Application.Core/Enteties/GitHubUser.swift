//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension ViewModel {
    struct GitHubUser {
        private init() {}
        var name  : String!
        init(some:E.GitHubUser) {
            name = some.name ?? ""
        }
        func pretyDescription() -> String {
            if let name = name {
                return "\(name)"
            }
            return ""
        }
    }
}


extension Entity {
    
    struct GitHubUser : Codable {
        
        private(set) var name       : String?
        private(set) var login      : String?
        private(set) var avatarUrl  : String?
        private(set) var url        : String?
        
        private enum CodingKeys: String, CodingKey {
            case name
            case avatarUrl = "avatar_url"
            case login
            case url
        }
        
        init(json:Dictionary<String, Any>) {
            if let login     = json["login"]      as? String { self.login = login }
            if let name      = json["name"]       as? String { self.name = name }
            if let avatarUrl = json["avatar_url"] as? String { self.avatarUrl = avatarUrl }
            if let url       = json["url"]        as? String { self.url = url }
        }
        
        init?(data:Data) {
            guard let object = try? JSONDecoder().decode(GitHubUser.self, from: data) else {
                AppLogs.DLogError("Error: Couldn't decode data into Blog")
                return nil
            }
            self = object
        }

        func isValid() -> Bool {
            if let name = self.name {
                return name.count > 0
            }
            return false
        }
        
        static func listFrom(jsonList:[Dictionary<String, Any>]) -> [E.GitHubUser] {
            let result : [E.GitHubUser] = jsonList.compactMap { (some) -> E.GitHubUser? in return E.GitHubUser(json: some) }
            return result
        }        
    }
}
