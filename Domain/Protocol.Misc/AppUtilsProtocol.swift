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

public protocol AppUtilsProtocol: class {

    // If there is internet; execute the code in the block. If not, present a warning
    var existsInternetConnection: Bool { get }
    
    func assertExistsInternetConnection(sender: BaseViewControllerMVPProtocol?, message: String, block:@escaping () -> Void)
    
    func downloadImage(imageURL: String, onFail: UIImage?, completion: @escaping (UIImage?) -> Void)

}
