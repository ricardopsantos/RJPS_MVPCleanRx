//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public protocol AppUtils_Protocol: class {

    // If there is internet; execute the code in the block. If not, present a warning
    var existsInternetConnection: Bool { get }
    
    func assertExistsInternetConnection(sender: GenericViewProtocol?, message: String, block:@escaping () -> Void)
    
    func downloadImage(imageURL: String, onFail: UIImage?, completion: @escaping (UIImage?) -> Void)

    func cachedValueIsOld(coreDatakey: String, maxLifeSpam: Int) -> Bool
}
