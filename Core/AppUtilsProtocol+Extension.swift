//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib_Base
import RJPSLib_Storage
import RxSwift
import RxCocoa
import RJPSLib_Networking
//
import Repositories
import AppResources
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Domain
import Factory

public extension AppUtilsProtocol {

    // swiftlint:enable rule_Coding
    
    func downloadImage(imageURL: String, onFail: UIImage?=nil, completion: @escaping (UIImage?) -> Void) {
        AppSimpleNetworkClient.downloadImageFrom(imageURL, caching: .hotOrCold) { (image) in completion(image ?? onFail) }
    }
    
    var existsInternetConnection: Bool {
        return RJS_Utils.existsInternetConnection
    }
    
    func assertExistsInternetConnection(sender: BaseViewControllerMVPProtocol?,
                                        message: String=Messages.noInternet.localised,
                                        block: @escaping () -> Void) {

        if !existsInternetConnection {
            let title  = Messages.alert.localised
            let option = Messages.ok.localised
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                switch action.style {
                case .default:
                    sender?.setActivityState(true)
                    DispatchQueue.executeWithDelay(delay: 1) {
                        sender?.setActivityState(false)
                        self.assertExistsInternetConnection(sender: sender, block: block)
                    }
                case .cancel: break
                case .destructive: break
                @unknown default: break
                }}))
            if let sender = sender {
                (sender as? UIViewController)?.present(alert, animated: true, completion: nil)
            }
        } else {
            block()
        }
    }
    
}
