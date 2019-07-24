//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension RJSLib {
    public struct PermissionsManager {
        
        private init() {}
        
        static func checkPHPhotoLibrary(completition:@escaping (Bool?)->()) {
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                RJSLib.Logs.DLog("Access is granted by user")
                completition(true)
                break
            case .notDetermined:
                RJSLib.Logs.DLog("Asking permision")
                completition(nil)
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        RJSLib.Logs.DLog("success")
                        completition(true)
                    }
                    else {
                        completition(false)
                    }
                })
                break
            case .restricted:
                RJSLib.Logs.DLog("User do not have access to photo album.")
                completition(false)
                break
            case .denied:
                RJSLib.Logs.DLog("User has denied the permission.")
                completition(false)
                break
            }
        }
    }
}






