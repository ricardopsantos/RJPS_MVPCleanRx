//
//  File.swift
//  Designables
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public enum UIKitViewFactoryElementTag: Int {
    // Simple
    case view = 1000
    case button
    case scrollView
    case stackView
    case imageView
    case textField
    case searchBar
    case label
    case tableView
    case `switch`
    case stackViewSpace
    
    // Composed
    case switchWithCaption
    case genericTitleAndValue
}
