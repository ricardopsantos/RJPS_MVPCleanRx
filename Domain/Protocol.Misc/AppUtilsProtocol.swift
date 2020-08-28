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

public protocol AppUtilsProtocol: class {

    // If there is internet; execute the code in the block. If not, present a warning
    var existsInternetConnection: Bool { get }
    
    func assertExistsInternetConnection(sender: BaseViewControllerMVPProtocol?, message: String, block:@escaping () -> Void)
    
    func downloadImage(imageURL: String, onFail: UIImage?, completion: @escaping (UIImage?) -> Void)

    // swiftlint:disable rule_Coding
    func genericCacheObserver<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String], apiObserver: Single<T>) -> Observable<T>
    func genericCacheObserverFallible<T: Codable>(_ some: T.Type, cacheKey: String, keyParams: [String]) -> Observable<T>
    // swiftlint:enable rule_Coding

}
