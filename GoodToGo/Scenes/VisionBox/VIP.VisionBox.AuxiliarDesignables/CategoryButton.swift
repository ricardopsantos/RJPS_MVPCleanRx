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
import RJPSLib
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Domain_VisionBox
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

// MARK: - Preview

@available(iOS 13.0.0, *)
struct CategoryButton_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.CategoryButton, context: Context) { }
    func makeUIView(context: Context) -> V.CategoryButton {
        V.CategoryButton(category: .cat1)
    }
}

@available(iOS 13.0.0, *)
struct CategoryButton_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        CategoryButton_UIViewRepresentable()
    }
}

// MARK: - View

extension V {

    open class CategoryButton: UIView {
        static let defaultSize: CGFloat = screenWidth / 4.0
        private let label = UILabel()
        private let image = UIImageView()
        private let imageBack = UIImageView()

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
                imageBack.image = UIImage(systemName: "circle.fill")
            } else {
                DevTools.Log.error("\(DevTools.Strings.not_iOS13) : Cant set imageBack")
            }

        }

        open override func layoutSubviews() {
            super.layoutSubviews()
        }

        private func setupView() {
            addSubview(imageBack)
            addSubview(image)
            addSubview(label)

            label.autoLayout.bottomToSuperview()
            label.autoLayout.widthToSuperview()
            label.textAlignment = .center
            label.font = UIFont.App.Styles.paragraphMedium.rawValue

            image.autoLayout.centerXToSuperview()
            image.autoLayout.centerYToSuperview(offset: -10)
            image.autoLayout.widthToSuperview(multiplier: 0.35)
            image.autoLayout.heightToSuperview(multiplier: 0.35)
            image.contentMode = .scaleAspectFit

            imageBack.autoLayout.centerXToSuperview()
            imageBack.autoLayout.centerYToSuperview(offset: -10)
            imageBack.autoLayout.widthToSuperview(multiplier: 0.9)
            imageBack.autoLayout.heightToSuperview(multiplier: 0.9)

            layoutColorsForNormal()
        }

        private func layoutColorsForNormal() {
            image.tintColor = .black
            label.textColor = UIColor.Pack1.grey_2.color
            imageBack.tintColor = UIColor.Pack1.grey_3.color.withAlphaComponent(0.2)

        }

        func layoutColorsForPressed() {
            image.tintColor = .white
            label.textColor = UIColor.Pack1.grey_2.color
            imageBack.tintColor = UIColor.Pack2.orange.color
            DispatchQueue.executeWithDelay(delay: RJS_Constants.defaultAnimationsTime) { [weak self] in
                self?.layoutColorsForNormal()
            }
        }
    }

}
