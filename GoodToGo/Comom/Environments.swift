//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import AppConstants
import Domain

struct AppEnvironments {

    enum AppMode: Int {
        case prod
        case qa
        case dev
    }

    private static var _current: AppMode? {
        didSet {
            AppLogger.log("Environment set to \(String(describing: _current))".uppercased())
        }
    }
    
    static var current: AppMode {
        return _current ?? .dev
    }

    static var isDev: Bool { return current == .dev }
    static var isQA: Bool { return current == .qa }
    static var isProd: Bool { return current == .prod }

    static func setup() {

        var appMode: String? {
            return (Bundle.main.infoDictionary?["BuildConfig_AppMode"] as? String)?.replacingOccurrences(of: "\\", with: "")
        }

        let block_recover = {
            AppLogger.log(appCode: .notPredicted)
            _current = .dev
        }

        if let mode = appMode {
            switch mode {
            case "Debug.Dev"  : _current = .dev
            case "Debug.QA"   : _current = .qa
            case "Debug.Prod" : _current = .prod
            case "Release"    : _current = .prod
            default           :
                block_recover()
            }
        } else {
            block_recover()
        }
    }
}
