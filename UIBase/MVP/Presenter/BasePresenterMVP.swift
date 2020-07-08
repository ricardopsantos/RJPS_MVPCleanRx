//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import UIKit
import RxSwift
import RJPSLib
import RxCocoa
//
import DevTools

open class BasePresenterMVP {
    deinit {
        DevTools.Log.logDeInit("\(BasePresenterMVP.self) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    public init () {}
    public var rxPublishRelay_error = PublishRelay<Error>()
    public var disposeBag: DisposeBag = DisposeBag()
   
}
