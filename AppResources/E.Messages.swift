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
    case alert = 0
    case noInternet
    case pleaseTryAgainLater
    case dismiss
    case ok
    case success
    case no
    case details
    case invalidURL
    case userName
    case password
    case login
    case invalidPassword
    case invalidEmail
    case invalidUserCrededentials
    case welcome
    case email

    public var localised: String {
        switch self {
        case .email: return AppResources.get("Email")
        case .welcome: return AppResources.get("Welcome")
        case .userName: return AppResources.get("Usernames")
        case .password: return AppResources.get("Password")
        case .invalidPassword: return AppResources.get("Invalid password")
        case .login: return AppResources.get("Login")
        case .noInternet: return AppResources.get("No Internet connection")
        case .pleaseTryAgainLater: return AppResources.get("Please try again latter")
        case .dismiss: return  AppResources.get("Dismiss")
        case .alert: return AppResources.get("Alert")
        case .ok: return AppResources.get("OK")
        case .success: return AppResources.get("Success")
        case .no: return AppResources.get("NO")
        case .details: return AppResources.get("Details")
        case .invalidURL: return AppResources.get("Invalid URL")
        case .invalidEmail: return AppResources.get("Invalid email")
        case .invalidUserCrededentials: return AppResources.get("Invalid user credential")
        }
    }

    public static func messageWith(error: Error) -> String {
        return pleaseTryAgainLater.localised
    }
}
