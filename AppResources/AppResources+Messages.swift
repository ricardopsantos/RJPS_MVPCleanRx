//
//  AppResources+Messages.swift
//  AppResources
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension AppResources {
    enum Messages: Int {
        case noInternet = 0
        case pleaseTryAgainLater
        case dismiss
        case alert
        case ok
        case success
        case no
        case details
        case invalidURL

        public var localised: String {
            switch self {
            case .noInternet: return get("NoInternetConnection")
            case .pleaseTryAgainLater: return get("Please try again latter")
            case .dismiss: return  get("Dismiss")
            case .alert: return get("Alert")
            case .ok: return get("OK")
            case .success: return get("Success")
            case .no: return get("NO")
            case .details: return get("Details")
            case .invalidURL: return get("Invalid URL")
            }
        }
    }
}
