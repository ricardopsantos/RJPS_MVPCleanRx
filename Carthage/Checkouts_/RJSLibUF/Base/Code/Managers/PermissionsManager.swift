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

        @available(*, deprecated)
        public static func checkPushNotificationsPermission(completetion:@escaping (Bool, String?) -> Void) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else {
                    RJS_Logs.message(_notGranted)
                    completetion(true, nil)
                    return
                }
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    completetion(true, "\(settings)")
                }
            }
        }

        @available(*, deprecated)
        public static func checkAudioPermission(completetion:@escaping (Bool) -> Void) {
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
                audioSession.requestRecordPermission({(granted: Bool) -> Void in
                    if granted {
                        completetion(true)
                    } else {
                        RJS_Logs.message(_notGranted)
                        completetion(false)
                    }
                })
            }
        }

        @available(*, deprecated)
        public static func checkPhotoLibrary(completetion:@escaping (Bool?) -> Void) {
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                completetion(true)
            case .notDetermined:
                RJS_Logs.message("Asking permission")
                completetion(nil)
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        completetion(true)
                    } else {
                        RJS_Logs.message(_notGranted)
                        completetion(false)
                    }
                })
            case .restricted:
                RJS_Logs.message("\(_notGranted) : User do not have access to photo album.")
                completetion(false)
            case .denied:
                RJS_Logs.message("\(_notGranted) : User has denied the permission.")
                completetion(false)
            case .limited:
                RJS_Logs.message("\(_notGranted) : User has limited permission.")
                completetion(false)
            @unknown default:
                RJS_Logs.message("Unknown.")
                completetion(false)
            }
        }
    }
}
