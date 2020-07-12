//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxSwift
import RxCocoa
//
import AppResources
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

open class BaseRouter {
    deinit {
        DevTools.Log.logDeInit("\(BaseRouter.self) was killed")
        NotificationCenter.default.removeObserver(self)
    }

    public init() { }
    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()
    public var rxPublishRelay_dismissView = PublishRelay<Void>() // PublishRelay model Events

}
