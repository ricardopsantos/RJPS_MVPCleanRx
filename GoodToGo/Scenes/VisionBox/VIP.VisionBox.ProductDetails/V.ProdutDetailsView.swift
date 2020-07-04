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
        return V.ProdutDetailsView()
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

        private lazy var imgDescriptionTitle: UIImageView = {
            UIKitFactory.imageView(image: Images.notFound.image)
        }()

        private lazy var lblDescriptionTitle: UILabel = {
            UIKitFactory.label(title: "lblDescriptionTitle", style: .title)
        }()

        private lazy var lblDescriptionValue: UILabel = {
            UIKitFactory.label(title: "lblDescriptionValue", style: .title)
        }()

        private lazy var lblEvaluateTitle: UILabel = {
            UIKitFactory.label(title: "lblEvaluateTitle", style: .title)
        }()

        private lazy var lblUserName: UILabel = {
            UIKitFactory.label(title: "lblUserName", style: .title)
        }()

        private lazy var imgEvaluateTitle: UIImageView = {
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
            some.backgroundColor = UIColor.Pack1.grey_1.color
            return some
        }()

        // MARK: - Mandatory

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(viewContainerTop)
            addSubview(viewContainerBottom)
            viewContainerBottom.addSubview(viewContainerCollection)
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
            viewSeparator.autoLayout.height(3)

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

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            DevTools.DebugView.paint(view: self, useBorderColors: true)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        func setupWith(someStuff viewModel: VM.ProdutDetails.Something.ViewModel) {

        }

        func setupWith(screenInitialState viewModel: VM.ProdutDetails.ScreenInitialState.ViewModel) {
        //    screenLayout = viewModel.screenLayout
        }
    }
}

// MARK: - Events capture

extension V.ProdutDetailsView {
  /*  var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.ProdutDetails.TableItem> {
        tableView.rx.modelSelected(VM.ProdutDetails.TableItem.self)
    }*/
}

extension V {
    final class AvatarView: UIView {

        public struct ViewModel {
            let image: UIImage
        }
        static let defaultSize: CGFloat = 50

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
            imgAvatar.image = viewModel.image
        }
    }
}
