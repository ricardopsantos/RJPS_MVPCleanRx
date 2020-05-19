//
//  GenericCache.swift
//  AppCore
//
//  Created by Ricardo Santos on 19/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RxSwift
import RJPSLib
//
import Factory

// swiftlint:disable rule_Coding

#warning("Were should i put this?")
public func genericCacheObserver<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String], apiObserver: Single<T>) -> Observable<T> {
    let cacheObserver = Observable<T>.create { observer in
        if let domainObject = RJS_DataModel.SimpleCache.getObject(some, withKey: cacheKey, keyParams: keyParams) {
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
