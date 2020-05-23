//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

public typealias Sample_UseCaseCompletionHandler = (_ result: Result<[String]>) -> Void
public protocol Sample_UseCaseProtocol: class {
    
    var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol! { get set }

    func operation1(canUseCache: Bool, completionHandler: @escaping Sample_UseCaseCompletionHandler)
    func operation2(param: String, completionHandler: @escaping Sample_UseCaseCompletionHandler)
}
