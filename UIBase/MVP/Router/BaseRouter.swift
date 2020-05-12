//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
//
import AppResources
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

open class BaseRouter {
    deinit {
        //AppLogger.log("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }

    public init() { }
    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()
    public var rxPublishRelay_dismissView = PublishRelay<Void>() // PublishRelay model Events

}
