//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

protocol Pet_ViewModelProtocol {
    var name: String { get }
    var image: UIImage { get }
    var ageText: String { get }
    var adoptionFeeText: String { get }
}
