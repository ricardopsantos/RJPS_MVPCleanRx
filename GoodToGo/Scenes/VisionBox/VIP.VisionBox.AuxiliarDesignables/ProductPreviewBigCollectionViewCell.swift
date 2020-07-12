//
//  ProductPreviewBigCollectionViewCell.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 05/07/2020.
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
import Domain_VisionBox
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

// MARK: - Preview

@available(iOS 13.0.0, *)
struct ProductPreviewBigCollectionViewCell_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProductPreviewBigCollectionViewCell, context: Context) { }
    func makeUIView(context: Context) -> V.ProductPreviewBigCollectionViewCell {
        let some = V.ProductPreviewBigCollectionViewCell()
        some.setup(viewModel: VisionBox.ProductModel.mockData.first!)
        return some
    }
}

@available(iOS 13.0.0, *)
struct ProductPreviewBigCollectionViewCell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProductPreviewBigCollectionViewCell_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class ProductPreviewBigCollectionViewCell: UICollectionViewCell {

        static let defaultHeight: CGFloat = screenHeight * 0.8
        static let defaultWidth: CGFloat = screenWidth * 0.9

        static var identifier: String {
            return String(describing: self)
        }

        var rxBtnBuyTap: Observable<Void> { productCardView.rxBtnBuyTap }

        private lazy var productCardView: ProductCardView = {
            V.ProductCardView()
        }()

        private lazy var imgBackground: ImageViewWithRoundedShadow = {
            ImageViewWithRoundedShadow()
        }()

        private lazy var imgProduct: UIImageView = {
            UIKitFactory.imageView()
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {

            contentView.backgroundColor = .clear

            contentView.addSubview(imgBackground)
            let offsetA: CGFloat = Designables.Sizes.Margins.defaultMargin
            let offsetB: CGFloat = offsetA * 3
            imgBackground.autoLayout.topToSuperview(offset: offsetA)
            imgBackground.autoLayout.bottomToSuperview(offset: -offsetA)
            imgBackground.autoLayout.leadingToSuperview(offset: offsetA)
            imgBackground.autoLayout.trailingToSuperview(offset: offsetB)

            contentView.addSubview(imgProduct)
            imgProduct.autoLayout.trailingToSuperview(offset: 0)
            imgProduct.autoLayout.centerYToSuperview(offset: -offsetB)
            imgProduct.autoLayout.heightToSuperview(multiplier: 0.5)
            imgProduct.autoLayout.widthToSuperview(multiplier: 0.5)
            imgProduct.contentMode = .scaleAspectFit
            imgProduct.addShadow(offset: CGSize(width: 5, height: 10), shadowType: .superHeavy)

            imgBackground.addSubview(productCardView)
            productCardView.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.bottomToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.heightToSuperview(multiplier: 0.3)

            //DevTools.DebugView.paint(view: self)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: VisionBox.ProductModel) {
            productCardView.setup(viewModel: viewModel)
            //imgBackground.image = UIImage(named: viewModel.backgroundImage)
            imgBackground.image = UIImage(named: viewModel.backgroundImage)
            let image = UIImage(named: viewModel.productImage)
            imgProduct.image = image
        }

    }
}
