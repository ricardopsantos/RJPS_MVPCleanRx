//
//  V.ProdutDetailsView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
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

// MARK: - Preview

@available(iOS 13.0.0, *)
struct ProductDetailsView_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProdutDetailsView, context: Context) { }
    func makeUIView(context: Context) -> V.ProdutDetailsView {
        let view = V.ProdutDetailsView()
        let screenInitialState = VM.ProductDetails.ScreenInitialState.ViewModel(productDetails: VisionBox.ProductModel.mockData.first!,
                                                                               userAvatarImage: Images.avatar.rawValue,
                                                                               userAvatarName: "Joe",
                                                                               productsList: VisionBox.ProductModel.mockData)
        view.setupWith(screenInitialState: screenInitialState)
        return view
    }
}

@available(iOS 13.0.0, *)
struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProductDetailsView_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class ProdutDetailsView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        private var collectionViewDataSource: [VisionBox.ProductModel] = [] {
            didSet {
                collectionView.reloadData()
            }
        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var viewContainerTop: UIView = {
            let some = UIView()
            some.backgroundColor = .yellow
            return some
        }()

        private lazy var viewContainerBottom: UIView = {
            UIView()
        }()

        private lazy var viewContainerCollection: UIView = {
            UIView()
        }()

        private lazy var collectionView: UICollectionView = {
             let viewLayout = UICollectionViewFlowLayout()
             viewLayout.scrollDirection = .horizontal
             let some = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
             return some
         }()

        private lazy var imgDescriptionTitle: UIImageView = {
            UIKitFactory.imageView(image: Images.notFound.image)
        }()

        private lazy var lblDescriptionTitle: UILabel = {
            let some = UIKitFactory.label(title: Messages.description.localised, style: .title)
            return some
        }()

        private lazy var lblDescriptionValue: UILabel = {
            let some = UIKitFactory.label(title: Messages.description.localised, style: .title)
            return some
        }()

        private lazy var lblEvaluateTitle: UILabel = {
            UIKitFactory.label(title: "Evaluate", style: .title)
        }()

        private lazy var lblUserName: UILabel = {
            UIKitFactory.label(title: "lblUserName", style: .title)
        }()

        private lazy var imgEvaluateTitle: UIImageView = {
            UIKitFactory.imageView(image: Images.notFound.image)
        }()

        private lazy var imgProduct: UIImageView = {
            UIKitFactory.imageView(image: Images.notFound.image)
        }()

        private lazy var productCardView: V.ProductCardView = {
            V.ProductCardView()
        }()

        private lazy var avatarView: V.AvatarView = {
            V.AvatarView()
        }()

        private lazy var viewSeparator: UIView = {
            let some = UIView()
            some.backgroundColor = UIColor.Pack1.grey_1.color.withAlphaComponent(FadeType.heavy.rawValue)
            return some
        }()

        // MARK: - Mandatory

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(viewContainerTop)
            viewContainerTop.addSubview(imgProduct)
            addSubview(viewContainerBottom)
            viewContainerBottom.addSubview(viewContainerCollection)
            viewContainerCollection.addSubview(collectionView)
            addSubview(productCardView)
            addSubview(imgDescriptionTitle)
            addSubview(lblDescriptionTitle)
            addSubview(lblDescriptionValue)
            addSubview(viewSeparator)
            addSubview(lblEvaluateTitle)
            addSubview(imgEvaluateTitle)
            addSubview(avatarView)
            addSubview(lblUserName)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            viewContainerTop.autoLayout.topToSuperview()
            viewContainerTop.autoLayout.leadingToSuperview()
            viewContainerTop.autoLayout.trailingToSuperview()
            viewContainerTop.autoLayout.heightToSuperview(multiplier: 0.4)

            imgProduct.autoLayout.centerInSuperview()
            imgProduct.autoLayout.widthToSuperview(multiplier: 0.75)
            imgProduct.autoLayout.heightToSuperview(multiplier: 0.75)
            imgProduct.addShadow()

            productCardView.autoLayout.topToBottom(of: viewContainerTop, offset: (-V.ProductCardView.defaultHeight * 0.25))
            productCardView.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.height(V.ProductCardView.defaultHeight)

            viewContainerBottom.autoLayout.bottomToSuperview()
            viewContainerBottom.autoLayout.leadingToSuperview()
            viewContainerBottom.autoLayout.trailingToSuperview()
            viewContainerBottom.autoLayout.topToBottom(of: viewContainerTop)

            lblDescriptionTitle.autoLayout.topToBottom(of: productCardView, offset: Designables.Sizes.Margins.defaultMargin)
            lblDescriptionTitle.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblDescriptionTitle.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            lblDescriptionValue.autoLayout.topToBottom(of: lblDescriptionTitle, offset: Designables.Sizes.Margins.defaultMargin)
            lblDescriptionValue.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblDescriptionValue.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            viewSeparator.autoLayout.topToBottom(of: lblDescriptionValue, offset: Designables.Sizes.Margins.defaultMargin)
            viewSeparator.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            viewSeparator.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            viewSeparator.autoLayout.height(0.5)

            lblEvaluateTitle.autoLayout.topToBottom(of: viewSeparator, offset: Designables.Sizes.Margins.defaultMargin)
            lblEvaluateTitle.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblEvaluateTitle.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            avatarView.autoLayout.topToBottom(of: lblEvaluateTitle, offset: Designables.Sizes.Margins.defaultMargin)
            avatarView.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            avatarView.autoLayout.width(V.AvatarView.defaultSize)
            avatarView.autoLayout.height(V.AvatarView.defaultSize)

            lblUserName.autoLayout.topToBottom(of: lblEvaluateTitle, offset: Designables.Sizes.Margins.defaultMargin)
            lblUserName.autoLayout.leadingToTrailing(of: avatarView, offset: Designables.Sizes.Margins.defaultMargin)
            lblUserName.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            viewContainerCollection.autoLayout.bottomToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            viewContainerCollection.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            viewContainerCollection.autoLayout.leading(to: lblUserName)
            viewContainerCollection.autoLayout.topToBottom(of: lblUserName, offset: Designables.Sizes.Margins.defaultMargin)

            collectionView.autoLayout.edgesToSuperview()

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            productCardView.applySecondaryStyle()
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(V.ProductPreviewSmallCollectionViewCell.self, forCellWithReuseIdentifier: V.ProductPreviewSmallCollectionViewCell.identifier)
            //DevTools.DebugView.paint(view: self, method: 1)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
            collectionView.backgroundColor = .clear
            lblDescriptionTitle.font = UIFont.App.Styles.paragraphMedium.rawValue
            lblDescriptionTitle.textColor = UIColor.black
            lblDescriptionValue.textColor = lblDescriptionTitle.textColor.withAlphaComponent(FadeType.regular.rawValue)
            lblDescriptionTitle.font = UIFont.App.Styles.paragraphMedium.rawValue
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

        func setupWith(screenInitialState viewModel: VM.ProductDetails.ScreenInitialState.ViewModel) {
            imgProduct.image = UIImage(named: viewModel.productDetails.productImage)
            collectionViewDataSource = viewModel.productsList
            lblUserName.text = viewModel.userAvatarName
            lblDescriptionValue.text = viewModel.productDetails.description
            avatarView.setup(viewModel: V.AvatarView.ViewModel(image: nil, imageName: viewModel.userAvatarImage))
            productCardView.setup(viewModel: viewModel.productDetails)
        }
    }
}

// MARK: - Events capture

extension V.ProdutDetailsView {

}

// MARK: - UICollectionViewDataSource

extension V.ProdutDetailsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: V.ProductPreviewSmallCollectionViewCell.identifier, for: indexPath) as! V.ProductPreviewSmallCollectionViewCell

        cell.setup(viewModel: collectionViewDataSource[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension V.ProdutDetailsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: V.ProductPreviewSmallCollectionViewCell.defaultWidth, height: V.ProductPreviewSmallCollectionViewCell.defaultHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultMargin = Designables.Sizes.Margins.defaultMargin
        return UIEdgeInsets(top: defaultMargin, left: defaultMargin, bottom: defaultMargin, right: defaultMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Designables.Sizes.Margins.defaultMargin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Designables.Sizes.Margins.defaultMargin
    }
}

extension V {
    final class AvatarView: UIView {

        public struct ViewModel {
            let image: UIImage?
            let imageName: String?
        }
        static let defaultSize: CGFloat = Designables.Sizes.AvatarView.defaultSize.width

        private lazy var imgAvatar: UIImageView = {
            UIKitFactory.imageView(image: Images.notFound.image)
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {
            addSubview(imgAvatar)
            imgAvatar.edgesToSuperview()
            imgAvatar.addCorner(radius: Self.defaultSize / 2.0)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: V.AvatarView.ViewModel) {
            if let image = viewModel.image {
                imgAvatar.image = image
            } else if let imageName = viewModel.imageName, let image = UIImage(named: imageName) {
                imgAvatar.image = image
            } else {
                imgAvatar.image = Images.notFound.image
            }
        }
    }
}

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
