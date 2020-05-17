//
//  UIButton+Extensions.swift
//  Designables
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

public extension UIButton {
    func disable() {
        self.isUserInteractionEnabled = false
        self.rjs.fadeTo(Designables.Constants.disabledViewAlpha)
    }

    func enable() {
        self.isUserInteractionEnabled = true
        self.fadeTo(1)
    }
}
