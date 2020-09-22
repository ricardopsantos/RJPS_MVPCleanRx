//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import ToastSwiftFramework
import DevTools
import RJSPLib_AppThemes
//
import AppConstants
import AppTheme
import Domain

public class MessagesManager: MessagesManagerProtocol {
    public func displayMessage(_ message: String, type: AlertType) {
        var style = ToastStyle()
        style.cornerRadius = 5
        style.displayShadow = true
        style.messageFont = RJS_Fonts.Styles.paragraphSmall.rawValue
        switch type {
        case .success: style.backgroundColor = ComponentColor.success.withAlphaComponent(FadeType.superLight.rawValue)
        case .warning: style.backgroundColor = ComponentColor.warning.withAlphaComponent(FadeType.superLight.rawValue)
        case .error: style.backgroundColor = ComponentColor.error.withAlphaComponent(FadeType.superLight.rawValue)
        }
        style.messageColor = .white
        DevTools.topViewController()?.view.makeToast(message, duration: 5, position: .top, style: style)
    }
}
