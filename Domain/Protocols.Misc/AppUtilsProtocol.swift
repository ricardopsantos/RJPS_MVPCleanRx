//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift

// AppUtilsProtocol implementation exists on a Protocol Extension

public protocol NetworkingOperationsUtilsProtocol: class {

    // If there is internet; execute the code in the block. If not, present a warning
    var existsInternetConnection: Bool { get }

    func downloadImage(imageURL: String, onFail: UIImage?, completion: @escaping (UIImage?) -> Void)

}
