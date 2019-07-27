//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension AppManagers {
    
    struct Ressources {
        private init() {}

        private static var _currentLanguageBundle : Bundle?
        private static var _defaultLanguage       : SelectedLanguage = .en
        private static var _storedLanguage : SelectedLanguage {
            if let storedLanguageString = AppGlobal.getWith(key: AppConstants.Dev.keyCoreDataSaveLang) {
                // We have a stored language!
                if let storedLanguage = SelectedLanguage(rawValue: Int(storedLanguageString) ?? _defaultLanguage.rawValue ) {
                    return storedLanguage
                }
            }
            return _defaultLanguage
        }
        static var selectedLanguage : SelectedLanguage = _storedLanguage {
            didSet{
                if(selectedLanguage != _storedLanguage) {
                    _currentLanguageBundle = nil
                    AppGlobal.saveWith(key: AppConstants.Dev.keyCoreDataSaveLang, value: "\(selectedLanguage.rawValue)")
                    AppLogs.DLogWarning("Language code changed to [\(selectedLanguage)]")
                }
            }
        }

        enum SelectedLanguage: Int { case en, pt }
        
        static func get(_ code:String) -> String { return resource(code) }

        struct Messages {
            private init() {}
            static var noInternet          : String { return get("NoInternetConnection") }
            static var pleaseTryAgainLater : String { return get("Please try again latter") }
            static var dismiss             : String { return get("Dismiss") }
            static var alert               : String { return get("Alert") }
            static var ok                  : String { return get("OK") }
            static var sucess              : String { return get("Sucess") }
            static var no                  : String { return get("NO") }
            static var details             : String { return get("Details") }
            static var invalidURL          : String { return get("Invalid URL") }
        }
        
 
        private static func resource(_ code : String/*, languageCode : SelectedLanguage = prepareLanguageCode()*/) -> String {
            guard !code.isEmpty else { return "" }
            
            if(_currentLanguageBundle == nil) {
                var file = ""
                switch selectedLanguage {
                case .en: file = "en"
                case .pt: file = "pt"
                }
                let path = Bundle.main.path(forResource: file, ofType: "lproj")
                guard path != nil else {
                    AppGlobal.assert(false, message: "Fail location ressource")
                    return code
                }
                
                _currentLanguageBundle = Bundle(path: path!)
                guard _currentLanguageBundle != nil else {
                    AppGlobal.assert(false, message: "Fail location ressource")
                    return code
                }
            }
            
            let result = _currentLanguageBundle!.localizedString(forKey: code, value: nil, table: nil)
            
            if(result == code) {
                AppLogs.DLogWarning("Ressource with code [\(code)] not found for language [\(selectedLanguage)]")
            }
            
            return result
        }
        
    }
}




