//
//  TitleTableSection.swift
//  Designables
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

open class DefaultTableViewSection: UILabelWithPadding {

    override open func layoutSubviews() {
        super.layoutSubviews()
        prepareLayout()
    }

    // To override
    func prepareLayout() {
        self.backgroundColor = UIColor.Pack2.lightGray.color
    }

    public var title: String? {
        didSet {
            label.text = title
        }
    }
}
