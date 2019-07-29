//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

protocol AppUtils_Protocol : class {

    // If there is internet; execture the code in the block. If not, presente a warging
    var existsInternetConnection : Bool { get }
    
    func assertExistsInternetConnection(sender:GenericView?, message:String, block:@escaping ()->())
    
    func downloadImage(imageURL:String, onFail:UIImage?, completion:@escaping (UIImage?) -> (Void)) -> Void

    func cachedValueIsOld(coreDatakey:String, maxLifeSpam:Int) -> Bool
}
