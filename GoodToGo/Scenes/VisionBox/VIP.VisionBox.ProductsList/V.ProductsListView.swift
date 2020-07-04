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
import RJPSLib
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
    func updateUIView(_ uiView: V.ProductsListView, context: Context) { }
    func makeUIView(context: Context) -> V.ProductsListView {
        let view = V.ProductsListView()
        let screenInitialState = VM.ProductsList.ScreenInitialState.ViewModel(products: VisionBox.ProductModel.mockData)
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
    class ProductsListView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        var rxFilter = BehaviorSubject<String?>(value: nil)

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var lblTitle: UILabel = {
            let some = UIKitFactory.label(style: .title)
            some.font = UIFont.App.Styles.headingBold.rawValue
            some.textColor = UIColor.black
            return some
         }()

        private lazy var searchBar: CustomSearchBar = {
            UIKitFactory.searchBar(placeholder: Messages.search.localised)
        }()

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
            addSubview(searchBar)
            addSubview(lblTitle)
            addSubview(collectionView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            searchBar.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            searchBar.autoLayout.widthToSuperview()
            searchBar.autoLayout.topToSuperview(offset: TopBar.defaultHeight(usingSafeArea: true))

            lblTitle.autoLayout.topToBottom(of: searchBar)
            lblTitle.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            collectionView.topToBottom(of: lblTitle, offset: 0)
            collectionView.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            collectionView.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            collectionView.bottomToSuperview(usingSafeArea: true)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(V.ProductPreviewBigCollectionViewCell.self, forCellWithReuseIdentifier: V.ProductPreviewBigCollectionViewCell.identifier)
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

            searchBar.rx.text
                .orEmpty
                .skip(1)
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .log(whereAmI())
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: disposeBag)
            searchBar.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { return }
                    guard self.searchBar.text!.count > 0 else { return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: self.disposeBag)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
            collectionView.backgroundColor = .white
        }

        // MARK: - Custom Getter/Setters

        private var collectionViewDataSource: [VisionBox.ProductModel] = [] {
            didSet {
                collectionView.fadeTo(0)
                DispatchQueue.executeWithDelay(delay: RJS_Constants.defaultAnimationsTime) { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                    if self.collectionViewDataSource.count > 0 {
                        self.collectionView.fadeTo(1)
                        if let text = self.collectionViewDataSource.first?.category.toString {
                            self.lblTitle.textAnimated = text
                        }
                    } 
                }
            }
        }

        func setupWith(filter viewModel: VM.ProductsList.Something.ViewModel) {
            collectionViewDataSource = viewModel.products
        }

        func setupWith(screenInitialState viewModel: VM.ProductsList.ScreenInitialState.ViewModel) {
            collectionViewDataSource = viewModel.products
        }

    }
}

// MARK: - Events capture

extension V.ProductsListView {

}

// MARK: - UICollectionViewDataSource

extension V.ProductsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = V.ProductPreviewBigCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! V.ProductPreviewBigCollectionViewCell

        cell.setup(viewModel: collectionViewDataSource[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension V.ProductsListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = itemWidth(for: self.frame.width, spacing: LayoutConstant.spacing)
        let width = screenWidth * 0.8
        return CGSize(width: width, height: V.ProductPreviewBigCollectionViewCell.defaultHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 1
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultMargin = Designables.Sizes.Margins.defaultMargin
        return UIEdgeInsets(top: 0, left: defaultMargin, bottom: 0, right: defaultMargin)
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

            contentView.backgroundColor = .clear

            contentView.addSubview(imgBackground)
            let offsetA: CGFloat = 10
            let offsetB: CGFloat = offsetA * 5
            imgBackground.autoLayout.topToSuperview(offset: offsetA)
            imgBackground.autoLayout.bottomToSuperview(offset: -offsetA)
            imgBackground.autoLayout.leadingToSuperview(offset: offsetA)
            imgBackground.autoLayout.trailingToSuperview(offset: offsetB)
            imgBackground.addShadow(offset: CGSize(width: 1, height: 3), shadowType: .heavyRegular)

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
            productCardView.autoLayout.heightToSuperview(multiplier: 0.25)

            DevTools.DebugView.paint(view: self)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: VisionBox.ProductModel) {
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
            let some = UIKitFactory.label(style: .notApplied)
            some.font = UIFont.App.Styles.headingSmall.rawValue
            some.textColor = UIColor.white
            return some
        }()

        private lazy var lblSpecification: UILabel = {
            let some = UIKitFactory.label(style: .notApplied)
            some.font = UIFont.App.Styles.paragraphBold.rawValue
            some.textColor = UIColor.white
            return some
        }()

        private lazy var lblPrice: UILabel = {
            let some = UIKitFactory.label(style: .notApplied)
            some.font = UIFont.App.Styles.headingBold.rawValue
            some.textColor = UIColor.Pack2.orange.color
            return some
        }()

        private lazy var btnBuy: UIButton = {
            UIKitFactory.button(title: "Buy now", style: .accept)
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
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
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
            btnBuy.height(Designables.Sizes.Button.defaultSize.height)

            cardView.addSubview(lblPrice)
            lblPrice.autoLayout.bottomToSuperview(offset: -Designables.Sizes.Margins.defaultMargin)
            lblPrice.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblPrice.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: VisionBox.ProductModel) {
            lblTitle.text = viewModel.name
            lblSpecification.text = "Specifications \(viewModel.specification) | Inventory \(viewModel.inventory)"
            lblPrice.text = viewModel.priceForCountry

        }
    }
}
