//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

typealias Sample_UseCaseCompletionHandler = (_ result: Result<[String]>) -> Void
protocol Sample_UseCaseProtocol : class {
    func operation1(canUseCache:Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler)
    func operation2(param:String, completionHandler: @escaping Sample_UseCaseCompletionHandler)
}


