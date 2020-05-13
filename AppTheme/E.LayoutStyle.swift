//
//  LayoutStyle.swift
//  AppTheme
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    enum LayoutStyle {
        case notApplied
        case regular
        case dismiss
        case alternative
    }
}

public extension UILabel {
    enum LayoutStyle {
        case notApplied /// not Applied
        case navigationBarTitle
        case title
        case value
        case error
    }
}
