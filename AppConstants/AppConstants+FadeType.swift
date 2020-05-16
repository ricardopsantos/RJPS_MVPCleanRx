//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public typealias ShadowType = FilterStrength
public typealias FadeType = FilterStrength

public enum FilterStrength: CGFloat, CaseIterable {
    case none         = 1
    case superLight   = 0.95
    case regular      = 0.75
    case heavyRegular = 0.6
    case heavy        = 0.4
    case superHeavy   = 0.1
}
