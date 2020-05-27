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
