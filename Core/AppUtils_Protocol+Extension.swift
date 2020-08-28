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
//
import Repositories
import AppResources
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Domain
import Factory

public extension AppUtils_Protocol {

    // swiftlint:disable rule_Coding
    func genericCacheObserverFallible<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String]) -> Observable<T> {
        let cacheObserver = Observable<T>.create { observer in
            if let cached = APICacheManager.shared.getSync(key: cacheKey, params: keyParams, type: some) {
                if let array = cached as? [Codable], array.count > 0 {
                    // If the response is an array, we only consider it if the array have elements
                     observer.on(.next(cached))
                     observer.on(.completed)
                 } else {
                     observer.on(.next(cached))
                     observer.on(.completed)
                 }
            }
            observer.on(.error(Factory.Errors.with(appCode: .notFound)))
            observer.on(.completed)
            return Disposables.create()
        }
        return cacheObserver
    }

    func genericCacheObserver<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String], apiObserver: Single<T>) -> Observable<T> {
        let cacheObserver = Observable<T>.create { observer in
            if let cached = APICacheManager.shared.getSync(key: cacheKey, params: keyParams, type: some) {
                if let array = cached as? [Codable], array.count > 0 {
                    // If the response is an array, we only consider it if the array have elements
                     observer.on(.next(cached))
                     observer.on(.completed)
                 } else {
                     observer.on(.next(cached))
                     observer.on(.completed)
                 }
            }
            observer.on(.error(Factory.Errors.with(appCode: .notFound)))
            observer.on(.completed)
            return Disposables.create()
        }.catchError { (_) -> Observable<T> in
            // No cache. Returning API call...
            return apiObserver.asObservable()
        }
        return cacheObserver
    }

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
