//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

typealias SampleA_UseCaseCompletionHandler = (_ result: Result<[E.Employee]>) -> Void
protocol SampleA_UseCaseProtocol : class {
    func operation1(canUseCache:Bool, completionHandler: @escaping SampleA_UseCaseCompletionHandler)
    func operation2(param:String, completionHandler: @escaping SampleA_UseCaseCompletionHandler)
}


