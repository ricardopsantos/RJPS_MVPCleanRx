//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public struct GitHubUserViewModel {
    private init() {}
    public var name: String!
    public init(some: GitHubUserResponseDto) {
        name = some.name ?? ""
    }
    public func pretyDescription() -> String {
        if let name = name {
            return "\(name)"
        }
        return ""
    }
}

public struct GitHubUserResponseDto: Codable {

    private(set) var name: String?
    private(set) var login: String?
    private(set) var avatarUrl: String?
    private(set) var url: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case avatarUrl = "avatar_url"
        case login
        case url
    }

    init(json: [String: Any]) {
        if let login     = json["login"]      as? String { self.login = login }
        if let name      = json["name"]       as? String { self.name = name }
        if let avatarUrl = json["avatar_url"] as? String { self.avatarUrl = avatarUrl }
        if let url       = json["url"]        as? String { self.url = url }
    }

    init?(data: Data) {
        guard let object = try? JSONDecoder().decode(GitHubUserResponseDto.self, from: data) else {
            AppLogger.error("Error: Couldn't decode data into Blog")
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

    static func listFrom(jsonList: [[String: Any]]) -> [GitHubUserResponseDto] {
        let result: [GitHubUserResponseDto] = jsonList.compactMap { (some) -> GitHubUserResponseDto? in return GitHubUserResponseDto(json: some) }
        return result
    }
}
