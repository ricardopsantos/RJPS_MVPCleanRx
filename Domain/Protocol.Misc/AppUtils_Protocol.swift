//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift

public protocol AppUtils_Protocol: class {

    // If there is internet; execute the code in the block. If not, present a warning
    var existsInternetConnection: Bool { get }
    
    func assertExistsInternetConnection(sender: BaseViewControllerMVPProtocol?, message: String, block:@escaping () -> Void)
    
    func downloadImage(imageURL: String, onFail: UIImage?, completion: @escaping (UIImage?) -> Void)

    @available(*, deprecated, message: "Use instead genericCacheObserver")
    func cachedValueIsOld(coreDatakey: String, maxLifeSpam: Int) -> Bool

    // swiftlint:disable rule_Coding
    func genericCacheObserver<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String], apiObserver: Single<T>) -> Observable<T>
    // swiftlint:enable rule_Coding

}
