//
//  AppResources+Messages.swift
//  AppResources
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// Shortcut for common app messages
public enum Messages: Int {
    case noInternet = 0
    case pleaseTryAgainLater
    case dismiss
    case alert
    case ok
    case success
    case no
    case details
    case invalidURL
    case userName
    case password
    case login
    case invalidPassword

    public var localised: String {
        switch self {
        case .userName: return AppResources.get("Usernames")
        case .password: return AppResources.get("Password")
        case .invalidPassword: return AppResources.get("Invalid password")
        case .login: return AppResources.get("Login")
        case .noInternet: return AppResources.get("NoInternetConnection")
        case .pleaseTryAgainLater: return AppResources.get("Please try again latter")
        case .dismiss: return  AppResources.get("Dismiss")
        case .alert: return AppResources.get("Alert")
        case .ok: return AppResources.get("OK")
        case .success: return AppResources.get("Success")
        case .no: return AppResources.get("NO")
        case .details: return AppResources.get("Details")
        case .invalidURL: return AppResources.get("Invalid URL")
        }
    }

    public static func messageWith(error: Error) -> String {
        return pleaseTryAgainLater.localised
    }
}
