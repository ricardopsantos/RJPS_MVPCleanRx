//
//  V.ProdutsListView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
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
struct ProductsListView_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProdutsListView, context: Context) { }
    func makeUIView(context: Context) -> V.ProdutsListView {
        let view = V.ProdutsListView()
        let screenInitialState = VM.ProdutsList.ScreenInitialState.ViewModel(title: "", subTitle: "", products: ProductModel.mockData)
        view.setupWith(screenInitialState: screenInitialState)
        return view
    }
}

@available(iOS 13.0.0, *)
struct ProductsListView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProductsListView_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class ProdutsListView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var collectionView: UICollectionView = {
             let viewLayout = UICollectionViewFlowLayout()
             viewLayout.scrollDirection = .horizontal
             let some = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
             return some
         }()

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(collectionView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            collectionView.edgesToSuperview(usingSafeArea: true)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(V.ProductPreviewBigCollectionViewCell.self, forCellWithReuseIdentifier: V.ProductPreviewBigCollectionViewCell.identifier)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
            collectionView.backgroundColor = .white
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        private var collectionViewDataSource: [ProductModel] = [] {
            didSet {
                collectionView.reloadData()
            }
        }

        func setupWith(someStuff viewModel: VM.ProdutsList.Something.ViewModel) {

        }

        func setupWith(screenInitialState viewModel: VM.ProdutsList.ScreenInitialState.ViewModel) {
            collectionViewDataSource = viewModel.products
        }

    }
}

// MARK: - Events capture

extension V.ProdutsListView {
   /* var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.ProdutsList.TableItem> {
        tableView.rx.modelSelected(VM.ProdutsList.TableItem.self)
    }*/
}

// MARK: - UICollectionViewDataSource

extension V.ProdutsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: V.ProductPreviewBigCollectionViewCell.identifier, for: indexPath) as! V.ProductPreviewBigCollectionViewCell

        cell.setup(viewModel: collectionViewDataSource[indexPath.row])
        cell.contentView.backgroundColor = .red
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension V.ProdutsListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = itemWidth(for: self.frame.width, spacing: LayoutConstant.spacing)
        let width = screenWidth * 0.8
        return CGSize(width: width, height: V.ProductPreviewBigCollectionViewCell.defaultHeight)
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

// MARK: - UICollectionViewCell

extension V {
    class ProductPreviewBigCollectionViewCell: UICollectionViewCell {

        static let defaultHeight: CGFloat = screenHeight * 0.8
        static let defaultWidth: CGFloat = screenWidth * 0.9

        static var identifier: String {
            return String(describing: self)
        }

        private lazy var productCardView: ProductCardView = {
            V.ProductCardView()
        }()

        private lazy var imgBackground: UIImageView = {
            UIKitFactory.imageView()
        }()

        private lazy var imgProduct: UIImageView = {
            UIKitFactory.imageView()
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {
            contentView.clipsToBounds = true
            contentView.layer.cornerRadius = 5
            contentView.backgroundColor = .white
            contentView.addShadow()

            contentView.addSubview(imgBackground)
            imgBackground.autoLayout.edgesToSuperview()

            contentView.addSubview(imgProduct)
            imgProduct.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            imgProduct.autoLayout.trailingToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            imgProduct.autoLayout.topToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            imgProduct.autoLayout.heightToSuperview(multiplier: 0.5)
            imgProduct.addShadow()

            contentView.addSubview(productCardView)
            productCardView.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.bottomToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            productCardView.autoLayout.heightToSuperview(multiplier: 0.25)

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: ProductModel) {
            productCardView.setup(viewModel: viewModel)
            imgBackground.image = UIImage(named: viewModel.backgroundImage)
            let image = UIImage(named: viewModel.productImage)
            imgProduct.image = image
        }
    }
}

extension V {
    final class ProductCardView: UIView {

        static let defaultHeight: CGFloat = 150

        private lazy var lblTitle: UILabel = {
            UIKitFactory.label(style: .notApplied)
        }()

        private lazy var lblSpecification: UILabel = {
            UIKitFactory.label(style: .notApplied)
        }()

        private lazy var lblPrice: UILabel = {
            UIKitFactory.label(style: .notApplied)
        }()

        private lazy var btnBuy: UIButton = {
            UIKitFactory.button(style: .accept)
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {

            let cardView = UIView()
            addSubview(cardView)
            cardView.edgesToSuperview()
            cardView.addCorner(radius: 5)
            cardView.backgroundColor = UIColor.white.withAlphaComponent(FadeType.heavy.rawValue)
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.5
            cardView.addSubview(blurEffectView)
            blurEffectView.edgesToSuperview()

            cardView.addSubview(lblTitle)
            lblTitle.autoLayout.topToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            cardView.addSubview(lblSpecification)
            lblSpecification.autoLayout.topToBottom(of: lblTitle, offset: Designables.Sizes.Margins.defaultMargin)
            lblSpecification.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblSpecification.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            cardView.addSubview(btnBuy)
            btnBuy.autoLayout.bottomToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            btnBuy.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            btnBuy.autoLayout.widthToSuperview(multiplier: 0.4)

            cardView.addSubview(lblPrice)
            lblPrice.autoLayout.bottomToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            lblPrice.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblPrice.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: ProductModel) {
            lblTitle.text = viewModel.name
            lblSpecification.text = "\(viewModel.specification) \(viewModel.inventory)"
            lblPrice.text = viewModel.price
        }
    }
}
