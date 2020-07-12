//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import Photos
import UserNotifications

/*
 
 <key>NSMicrophoneUsageDescription</key>
 <string>Need microphone access for uploading videos</string>
 
 <key>NSCameraUsageDescription</key>
 <string>Need camera access for uploading Images</string>
 
 <key>NSLocationUsageDescription</key>
 <string>Need location access for updating nearby friends</string>
 
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>This app will use your location to show cool stuffs near you.</string>
 
 <key>NSPhotoLibraryUsageDescription</key>
 <string>Need Library access for uploading Images</string>
 
 */

extension RJSLib {
    public struct PermissionsManager {
        
        private init() {}
        
        private static let _notGranted: String = "Not granted"
        public static func checkPushNotificationsPermission(completition:@escaping (Bool, String?) -> Void) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else {
                    RJS_Logs.message(_notGranted)
                    completition(true, nil)
                    return
                }
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    completition(true, "\(settings)")
                }
            }
        }
        
        public static func checkAudioPermission(completition:@escaping (Bool) -> Void) {
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
                audioSession.requestRecordPermission({(granted: Bool) -> Void in
                    if granted {
                        completition(true)
                    } else {
                        RJS_Logs.message(_notGranted)
                        completition(false)
                    }
                })
            }
        }
        
        public static func checkPHPhotoLibrary(completition:@escaping (Bool?) -> Void) {
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                completition(true)
            case .notDetermined:
                RJS_Logs.message("Asking permision")
                completition(nil)
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        completition(true)
                    } else {
                        RJS_Logs.message(_notGranted)
                        completition(false)
                    }
                })
            case .restricted:
                RJS_Logs.message("\(_notGranted) : User do not have access to photo album.")
                completition(false)
            case .denied:
                RJS_Logs.message("\(_notGranted) : User has denied the permission.")
                completition(false)
            @unknown default:
                RJS_Logs.message("Unknow.")
                completition(false)
            }
        }
    }
}
