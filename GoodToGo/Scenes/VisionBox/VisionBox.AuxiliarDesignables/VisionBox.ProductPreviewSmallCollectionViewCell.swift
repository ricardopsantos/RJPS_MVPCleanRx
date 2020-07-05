//
//  VisionBox.ProductPreviewSmallCollectionViewCell.swift
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
struct ProductPreviewSmallCollectionViewCell_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProductPreviewSmallCollectionViewCell, context: Context) { }
    func makeUIView(context: Context) -> V.ProductPreviewSmallCollectionViewCell {
        let some = V.ProductPreviewSmallCollectionViewCell()
        some.setup(viewModel: VisionBox.ProductModel.mockData.first!)
        return some
    }
}

@available(iOS 13.0.0, *)
struct ProductPreviewSmallCollectionViewCell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProductPreviewSmallCollectionViewCell_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class ProductPreviewSmallCollectionViewCell: UICollectionViewCell {

        static let defaultHeight: CGFloat = screenHeight * 0.2
        static let defaultWidth: CGFloat  = screenWidth * 0.2

        static var identifier: String {
            return String(describing: self)
        }

        private lazy var imgProduct: UIImageView = {
            UIKitFactory.imageView()
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {
            let cellColor = UIColor.white.withAlphaComponent(0.4)
            contentView.clipsToBounds = true
            contentView.layer.cornerRadius = 10
            contentView.addShadow()

            contentView.addSubview(imgProduct)
            imgProduct.autoLayout.edgesToSuperview()
            imgProduct.contentMode = .scaleAspectFit
            imgProduct.addShadow()

            contentView.backgroundColor = cellColor
            self.backgroundColor = cellColor
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: VisionBox.ProductModel) {
            let image = UIImage(named: viewModel.productImage)
            imgProduct.image = image
        }
    }
}
