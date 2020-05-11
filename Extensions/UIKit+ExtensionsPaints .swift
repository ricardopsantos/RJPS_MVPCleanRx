//
//  File.swift
//  Extensions
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {

    /// Sintax sugar for [func changeImageColor(to color: UIColor)]
    func paintImageWith(color: UIColor) {
        changeImageColor(to: tintColor)
    }

    /// Turn image into template image, and apply color
    func changeImageColor(to color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

public extension UIButton {

    /// Sintax sugar for [func changeImageColor(to color: UIColor)]
    func paintImageWith(color: UIColor) {
        changeImageColor(to: color)
    }

    /// Turn image into template image, and apply color
    func changeImageColor(to color: UIColor) {
        guard let origImage = self.image(for: state) else { return }
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        setImageForAllStates(tintedImage, tintColor: color)
        tintColor = color
    }

    func setImageForAllStates(_ image: UIImage, tintColor: UIColor?) {
        let tintedImage = (tintColor != nil) ? image.withRenderingMode(.alwaysTemplate) : image
        setImage(tintedImage, for: .normal)
        setImage(tintedImage, for: .disabled)
        setImage(tintedImage, for: .highlighted)
        setImage(tintedImage, for: .focused)
        if tintColor != nil {
            changeImageColor(to: tintColor!)
        }
    }
}
