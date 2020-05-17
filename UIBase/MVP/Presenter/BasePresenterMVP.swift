//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self) was killed") }
        NotificationCenter.default.removeObserver(self)
    }
    public init () {}
    public var rxPublishRelay_error = PublishRelay<Error>()
    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()
   
}
