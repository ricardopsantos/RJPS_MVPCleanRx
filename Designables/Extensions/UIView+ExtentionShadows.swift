//
//  UIView+ExtentionShadows.swift
//  Designables
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import AppConstants
public extension UIView {
    func addShadow(color: UIColor = AppConstants.Shadows.shadowColor,
                   offset: CGSize = AppConstants.Shadows.offset,
                   radius: CGFloat = AppConstants.Shadows.offset.height) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
