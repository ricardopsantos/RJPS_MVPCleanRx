//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import DevTools

public extension AppResources {

    private init() {}

    static func get(_ code: String) -> String { return resource(code) }

    static var selectedLanguage: SelectedLanguage = storedLanguage {
        didSet {
            if selectedLanguage != storedLanguage {
                currentLanguageBundle = nil
                saveWith(key: AppConstants.Dev.keyCoreDataSaveLang, value: "\(selectedLanguage.rawValue)")
                DevTools.AppLogger.warning("Language code changed to [\(selectedLanguage)]")
            }
        }
    }

}

// MARK: - Private

public extension AppResources {

    private static var currentLanguageBundle: Bundle?
    private static var defaultLanguage: SelectedLanguage = .en
    private static var storedLanguage: SelectedLanguage {
        if let storedLanguageString = getWith(key: AppConstants.Dev.keyCoreDataSaveLang) {
            // We have a stored language!
            if let storedLanguage = SelectedLanguage(rawValue: Int(storedLanguageString) ?? defaultLanguage.rawValue ) {
                return storedLanguage
            }
        }
        return defaultLanguage
    }

    private static func resource(_ code: String) -> String {
        guard !code.isEmpty else { return "" }

        if currentLanguageBundle == nil {
            var file = ""
            switch selectedLanguage {
            case .en: file = "en"
            case .pt: file = "pt"
            }
            let path = Bundle.main.path(forResource: file, ofType: "lproj")
            guard path != nil else {
                DevTools.assert(false, message: "Fail location resource")
                return code
            }

            currentLanguageBundle = Bundle(path: path!)
            guard currentLanguageBundle != nil else {
                DevTools.assert(false, message: "Fail location resource")
                return code
            }
        }

        return currentLanguageBundle!.localizedString(forKey: code, value: nil, table: nil)
    }
}
