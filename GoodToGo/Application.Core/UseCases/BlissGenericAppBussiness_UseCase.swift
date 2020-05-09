//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import AppDomain

extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
    class BlissGenericAppBussiness_UseCase: GenericUseCase, BlissGenericAppBussiness_UseCaseProtocol {
        
        var generic_CacheRepositoryProtocol: Generic_CacheRepositoryProtocol!
        var generic_LocalStorageRepository: Generic_LocalStorageRepositoryProtocol!
        var rxPublishRelayAppicationDidReceivedData: PublishRelay = PublishRelay<Void>() // PublishRelay model Events

        func handle(url: URL) {
            func getKeyValsFromURL(url: URL) -> [String: String]? {
                let urlUriKeysValuesSeparator = "?"
                let urlUriKeyValueSeparator   = "="
                var results = [String: String]()
                guard let query = url.query else { return results }
                let keyValues = query.components(separatedBy: urlUriKeysValuesSeparator)
                if keyValues.count > 0 {
                    for pair in keyValues {
                        let kv = pair.components(separatedBy: urlUriKeyValueSeparator)
                        if kv.count > 1 {
                            results.updateValue(kv[1], forKey: kv[0])
                        }
                    }
                }
                return results
            }
            
            if let parans = getKeyValsFromURL(url: url) {
                parans.forEach { (kv) in
                    if kv.key == AppConstants.Bliss.DeepLinks.questionsFilter {
                        setNeedToOpenScreen(screen: V.BlissQuestionsList_View.className, key: kv.key, value: kv.value)
                    } else if kv.key == AppConstants.Bliss.DeepLinks.questionId {
                        setNeedToOpenScreen(screen: V.BlissDetails_View.className, key: kv.key, value: kv.value)
                    } else {
                        assert(false, message: RJS_Constants.notPredicted + "\(kv)")
                    }                    
                }
                rxPublishRelayAppicationDidReceivedData.accept(())
            }
        }
        
        func screenHaveHandledData(screen: String) {
            if let object = generic_LocalStorageRepository.with(prefix: screen) {
                if let key  = object.key {
                    generic_LocalStorageRepository.deleteWith(key: key)
                }
            }
        }
        
        // The first param is a key, and the second a value
        func screenHaveDataToHandle(screen: String) -> (String, String)? {
            if let object = generic_LocalStorageRepository.with(prefix: screen) {
                if let key  = object.key {
                    let value = object.value
                    let parts = key.splitBy(".")
                    if parts.count == 2 {
                        return (parts[1], value!)
                    }
                }
            }
            return nil
        }
        
        func setNeedToOpenScreen(screen: String, key: String, value: String) {
            let storedKey = "\(screen).\(key)"
            _ = generic_LocalStorageRepository.save(key: storedKey, value: value, expireDate: RJS_DataModel.baseDate.add(minutes: 1))
            if AppEnvironments.isDev() {
                let stored = screenHaveDataToHandle(screen: screen)
                assert(stored!.0 == key)
                assert(stored!.1 == value)
            }
        }
        
    }
}
