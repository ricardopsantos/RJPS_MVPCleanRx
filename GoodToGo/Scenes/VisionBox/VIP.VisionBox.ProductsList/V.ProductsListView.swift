//
//  V.ProductsListView.swift
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
import RJPSLib_Base
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
        var rxSelected = BehaviorSubject<VisionBox.ProductModel?>(value: nil)

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var lblTitle: UILabel = {
            let some = UIKitFactory.label(style: .title)
            some.font = AppFonts.Styles.headingBold.rawValue
            some.textColor = UIColor.black
            return some
         }()

        private lazy var searchBar: CustomSearchBar = {
            //UISearchBar()
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
            searchBar.autoLayout.topToSuperview(offset: Designables.Sizes.Margins.defaultMargin, usingSafeArea: true)

            lblTitle.autoLayout.topToBottom(of: searchBar, offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.leadingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            collectionView.topToBottom(of: lblTitle, offset: 5)
            collectionView.autoLayout.leadingToSuperview()
            collectionView.autoLayout.trailingToSuperview()
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
            self.backgroundColor = AppColors.background
            collectionView.backgroundColor = .clear
            searchBar.backgroundColor = self.backgroundColor
            searchBar.tintColor = self.backgroundColor
            searchBar.barTintColor = self.backgroundColor
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

        func setupWith(filter viewModel: VM.ProductsList.FilterProducts.ViewModel) {
            collectionViewDataSource = viewModel.products
        }

        func setupWith(screenInitialState viewModel: VM.ProductsList.ScreenInitialState.ViewModel) {
            collectionViewDataSource = viewModel.products
        }

    }
}

// MARK: - UICollectionViewDataSource

extension V.ProductsListView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = collectionViewDataSource[indexPath.row]
        rxSelected.onNext(selected)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = V.ProductPreviewBigCollectionViewCell.identifier
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                         for: indexPath) as? V.ProductPreviewBigCollectionViewCell {
            cell.setup(viewModel: collectionViewDataSource[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
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
