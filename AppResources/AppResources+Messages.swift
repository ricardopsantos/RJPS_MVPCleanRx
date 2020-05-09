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

    enum SelectedLanguage: Int { case en, pt }

    static var selectedLanguage: SelectedLanguage = _storedLanguage {
        didSet {
            if selectedLanguage != _storedLanguage {
                _currentLanguageBundle = nil
                saveWith(key: AppConstants.Dev.keyCoreDataSaveLang, value: "\(selectedLanguage.rawValue)")
                DevTools.AppLogger.warning("Language code changed to [\(selectedLanguage)]")
            }
        }
    }

    static func get(_ code: String) -> String { return resource(code) }

    struct Messages {
        private init() {}
        public static var noInternet: String { return get("NoInternetConnection") }
        public static var pleaseTryAgainLater: String { return get("Please try again latter") }
        public static var dismiss: String { return get("Dismiss") }
        public static var alert: String { return get("Alert") }
        public static var ok: String { return get("OK") }
        public static var success: String { return get("Success") }
        public static var no: String { return get("NO") }
        public static var details: String { return get("Details") }
        public static var invalidURL: String { return get("Invalid URL") }
    }

}

// MARK:- Private

public extension AppResources {

    private static var _currentLanguageBundle: Bundle?
    private static var _defaultLanguage: SelectedLanguage = .en
    private static var _storedLanguage: SelectedLanguage {
        if let storedLanguageString = getWith(key: AppConstants.Dev.keyCoreDataSaveLang) {
            // We have a stored language!
            if let storedLanguage = SelectedLanguage(rawValue: Int(storedLanguageString) ?? _defaultLanguage.rawValue ) {
                return storedLanguage
            }
        }
        return _defaultLanguage
    }

    private static func resource(_ code: String) -> String {
        guard !code.isEmpty else { return "" }

        if _currentLanguageBundle == nil {
            var file = ""
            switch selectedLanguage {
            case .en: file = "en"
            case .pt: file = "pt"
            }
            let path = Bundle.main.path(forResource: file, ofType: "lproj")
            guard path != nil else {
                assert(false, message: "Fail location resource")
                return code
            }

            _currentLanguageBundle = Bundle(path: path!)
            guard _currentLanguageBundle != nil else {
                assert(false, message: "Fail location resource")
                return code
            }
        }

        return _currentLanguageBundle!.localizedString(forKey: code, value: nil, table: nil)
    }
}
