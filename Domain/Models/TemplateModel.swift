//
//  TemplateModel.swift
//  Domain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import DevTools
import PointFreeFunctions

// MARK: - Template

public struct TemplateModel: ModelEntityProtocol {
    public let `id`, state: String?

    enum CodingKeys: String, CodingKey {
        case id
        case state
    }

    public init(id: String, state: String) {
        self.id = id
        self.state = state
    }

    public var debugDescription: String {
        return "ID: \(id ?? "nil") | State: \(state ?? "nil")"
    }
}

public extension TemplateModel {
    static func generateMockedValue() -> TemplateModel {
        var accounts: [String] = []
        var funds: [Int] = []
        for _ in 0..<randomInt(min: 0, max: 5) {
            funds.append(randomInt(min: 0, max: 5))
        }
        for _ in 0..<randomInt(min: 0, max: 5) {
            accounts.append("hiii")
        }
        return TemplateModel(id: randomStringWith(prefix: "id"), state: randomStringWith(prefix: "state"))
    }
}
