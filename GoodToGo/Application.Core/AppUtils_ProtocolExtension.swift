//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

extension AppUtils_Protocol {
    
    func downloadImage(imageURL:String, onFail:UIImage?=nil, completion:@escaping (UIImage?) -> (Void)) -> Void {
        guard !imageURL.isEmpty else { return completion(AppImages.notFound) }
        AppSimpleNetworkClient.downloadImageFrom(imageURL, caching: .fileSystem) { (image) in completion(image ?? onFail) }
    }
    
    var existsInternetConnection : Bool {
        return RJS_Utils.existsInternetConnection()
    }
    
    
    func assertExistsInternetConnection(sender:GenericView?,
                                        message:String=AppMessages.noInternet,
                                        block:@escaping ()->()) {

        if(!existsInternetConnection) {
            let title   = AppRessources.get("Alert")
            let option  = AppMessages.ok
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                switch action.style{
                case .default:
                    sender?.setActivityState(true)
                    DispatchQueue.executeWithDelay (delay:1) {
                        sender?.setActivityState(false)
                        self.assertExistsInternetConnection(sender: sender, block: block)
                    }
                case .cancel: break
                case .destructive: break
                @unknown default: break
                }}))
            if let sender = sender {
                (sender as UIViewController).present(alert, animated: true, completion: nil)
            }
        }
        else {
            block()
        }
    }
    
}


