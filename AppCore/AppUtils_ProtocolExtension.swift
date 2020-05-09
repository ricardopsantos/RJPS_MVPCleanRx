//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import AppDomain

public extension AppUtils_Protocol {
    
    func cachedValueIsOld(coreDatakey: String, maxLifeSpam: Int) -> Bool {
        var cachedValueIsOld = false
        if let lastTime = RJS_DataModel.dateWith(key: coreDatakey) {
            let cacheLifeSpam = maxLifeSpam//5 * 60 // 5m cache
            if let secondsSinceLastUpdate = Calendar.current.dateComponents(Set<Calendar.Component>([.second]), from: lastTime, to: RJS_DataModel.baseDate).second {
                cachedValueIsOld = secondsSinceLastUpdate >= cacheLifeSpam
            }
        }
        return cachedValueIsOld
    }
    
    func downloadImage(imageURL: String, onFail: UIImage?=nil, completion: @escaping (UIImage?) -> Void) {
        guard !imageURL.isEmpty else { return completion(onFail) }
        AppSimpleNetworkClient.downloadImageFrom(imageURL, caching: .fileSystem) { (image) in completion(image ?? onFail) }
    }
    
    var existsInternetConnection: Bool {
        return RJS_Utils.existsInternetConnection()
    }
    
    func assertExistsInternetConnection(sender: GenericViewProtocol?,
                                        message: String=AppMessages.noInternet.localised,
                                        block: @escaping () -> Void) {

        if !existsInternetConnection {
            let title  = AppMessages.alert.localised
            let option = AppMessages.ok.localised
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
                (sender as! UIViewController).present(alert, animated: true, completion: nil)
            }
        } else {
            block()
        }
    }
    
}
