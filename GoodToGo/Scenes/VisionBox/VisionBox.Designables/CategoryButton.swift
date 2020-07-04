//
//  CategoryButton.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

extension V {

    open class CategoryButton: UIView {
        static let defaultSize: CGFloat = screenWidth / 4.0
        private let label = UILabel()
        private let back = UIView()
        private let image = UIImageView()

        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        public convenience init(category: VisionBox.Category) {
            self.init(frame: .zero)
            label.text = category.toString
            tag = category.tag
            if #available(iOS 13.0, *) {
                image.image = UIImage(systemName: category.imageName)
            }
        }

        open override func layoutSubviews() {
            super.layoutSubviews()
        }

        private func setupView() {
            addSubview(back)
            addSubview(image)
            addSubview(label)

            label.autoLayout.bottomToSuperview()
            label.autoLayout.widthToSuperview()
            label.textAlignment = .center
            label.apply(style: .title)

            back.addCorner(radius: 10)
            back.autoLayout.centerXToSuperview()
            back.autoLayout.centerYToSuperview(offset: -10)
            back.autoLayout.widthToSuperview(multiplier: 0.6)
            back.autoLayout.heightToSuperview(multiplier: 0.6)
            back.backgroundColor = .red

            image.autoLayout.centerXToSuperview()
            image.autoLayout.centerYToSuperview(offset: -10)
            image.autoLayout.widthToSuperview(multiplier: 0.5)
            image.autoLayout.heightToSuperview(multiplier: 0.5)
            image.contentMode = .scaleAspectFit
            image.backgroundColor = .clear

            self.backgroundColor = UIColor.blue.withAlphaComponent(0.1)

        }
    }

}
