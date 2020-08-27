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
            if let domainObject = APICacheManager.shared.getSync(key: cacheKey, params: keyParams, type: some) {
            //if let domainObject = RJS_DataModel.PersistentSimpleCacheWithTTL.shared.getObject(some, withKey: cacheKey, keyParams: keyParams) {
                if let array = domainObject as? [Codable], array.count > 0 {
                    // If the response is an array, we only consider it if the array have elements
                     observer.on(.next(domainObject))
                     observer.on(.completed)
                 } else {
                     observer.on(.next(domainObject))
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
            if let domainObject = APICacheManager.shared.getSync(key: cacheKey, params: keyParams, type: some) {
            //if let domainObject = RJS_DataModel.PersistentSimpleCacheWithTTL.shared.getObject(some, withKey: cacheKey, keyParams: keyParams) {
                if let array = domainObject as? [Codable], array.count > 0 {
                    // If the response is an array, we only consider it if the array have elements
                     observer.on(.next(domainObject))
                     observer.on(.completed)
                 } else {
                     observer.on(.next(domainObject))
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

    @available(*, deprecated, message: "Use instead genericCacheObserver")
    func cachedValueIsOld(coreDatakey: String, maxLifeSpam: Int) -> Bool {
        var cachedValueIsOld = false
        if let lastTime = RJS_DataModel.StorableKeyValue.dateWith(key: coreDatakey) {
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
