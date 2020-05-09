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

class GenericPresenter {
    deinit {
        AppLogger.log("\(self) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    
    var rxPublishRelay_error = PublishRelay<Error>()
    var reachabilityService: ReachabilityService! = try! DefaultReachabilityService() // try! is only for simplicity sake
    var disposeBag: DisposeBag = DisposeBag()
   
}
