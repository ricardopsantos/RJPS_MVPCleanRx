//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib_Networking

public typealias Samples_LocalRepositoryCompletionHandler = (_ result: Result<Void>) -> Void
//public protocol Samples_LocalRepositoryProtocol: class {
    //func local_OperationA(someList: [Employee.ResponseDto], completionHandler: @escaping Samples_LocalRepositoryCompletionHandler)
    //func local_OperationB(someList: [Employee.ResponseDto], completionHandler: @escaping Samples_LocalRepositoryCompletionHandler)
//}

public typealias Samples_NetWorkRepositoryCompletionHandler = (_ result: Result<RJS_SimpleNetworkClientResponse<[Employee.ResponseDto]>>) -> Void
public protocol Samples_NetWorkRepositoryProtocol: class {
    func netWork_OperationA(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler)
    func netWork_OperationB(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler)
}
