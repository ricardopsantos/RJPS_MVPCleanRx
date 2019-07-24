//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RJPSLib
import RxCocoa

class GenericRouter {
    deinit {
        AppLogs.DLog("\(self) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    
    var reachabilityService: ReachabilityService! = try! DefaultReachabilityService() // try! is only for simplicity sake
    var disposeBag : DisposeBag = DisposeBag()
    var rxPublishRelay_dismissView = PublishRelay<Void>() // PublishRelay model Events

}
