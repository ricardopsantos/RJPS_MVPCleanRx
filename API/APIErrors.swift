//
//  APIErrors.swift
//  API
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension E {
    enum APIErrors: Error {
        case invalidURL(url: String)
        case notImplemented
    }
}
