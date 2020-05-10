//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

public typealias Sample_UseCaseCompletionHandler = (_ result: Result<[String]>) -> Void
public protocol Sample_UseCaseProtocol: class {
    
    var generic_LocalStorageRepository: LocalStorageRepositoryProtocol! { get set }

    func operation1(canUseCache: Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler)
    func operation2(param: String, completionHandler: @escaping Sample_UseCaseCompletionHandler)
}
