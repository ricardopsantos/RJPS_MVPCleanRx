//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import Core
import AppConstants
import PointFreeFunctions
import Domain
import Domain_Bliss

public class BlissGenericAppBusiness_UseCase: GenericUseCase, BlissGenericAppBusinessUseCaseProtocol {

    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!
    public var rxPublishRelayApplicationDidReceivedData: PublishRelay = PublishRelay<Void>() // PublishRelay model Events

    public func handle(url: URL) {
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

        #warning("fix deeplinks")
        /*
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
            rxPublishRelayApplicationDidReceivedData.accept(())
        }*/
    }

    public func screenHaveHandledData(screen: String) {
        if let object = generic_LocalStorageRepository.with(prefix: screen) {
            if let key  = object.key {
                generic_LocalStorageRepository.deleteWith(key: key)
            }
        }
    }

    // The first param is a key, and the second a value
    public func screenHaveDataToHandle(screen: String) -> (String, String)? {
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

    public func setNeedToOpenScreen(screen: String, key: String, value: String) {
        let storedKey = "\(screen).\(key)"
        _ = generic_LocalStorageRepository.save(key: storedKey, value: value, expireDate: RJS_DataModel.baseDate.add(minutes: 1))
    }
}
