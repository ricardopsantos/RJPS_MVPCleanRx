//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//
import AppDomain

typealias Samples_LocalRepositoryCompletionHandler = (_ result: Result<Void>) -> Void
protocol Samples_LocalRepositoryProtocol: class {
    func local_OperationA(someList: [Employee.ResponseDto], completionHandler: @escaping Samples_LocalRepositoryCompletionHandler)
    func local_OperationB(someList: [Employee.ResponseDto], completionHandler: @escaping Samples_LocalRepositoryCompletionHandler)
}

typealias Samples_NetWorkRepositoryCompletionHandler = (_ result: Result<NetworkClientResponse<[Employee.ResponseDto]>>) -> Void
protocol Samples_NetWorkRepositoryProtocol: class {
    func netWork_OperationA(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler)
    func netWork_OperationB(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler)
}
