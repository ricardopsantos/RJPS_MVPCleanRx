//
//  ProductCardView.swift
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
import Domain_VisionBox
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

// MARK: - Preview

@available(iOS 13.0.0, *)
struct ProductCardView_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProductCardView, context: Context) { }
    func makeUIView(context: Context) -> V.ProductCardView {
        let some = V.ProductCardView()
        let viewModel = VisionBox.ProductModel.mockData.first
        some.setup(viewModel: viewModel!)
        return some
    }
}

@available(iOS 13.0.0, *)
struct ProductCardView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProductCardView_UIViewRepresentable()
    }
}

// MARK: - View

extension V {

    //final class ProductCardView: ViewWithRoundShadow {
    final class ProductCardView: UIView {

        static let defaultHeight: CGFloat = 150
        var disposeBag = DisposeBag()

        var rxBtnBuyTap: Observable<Void> { btnBuy.rx.tapSmart(disposeBag) }
        var blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))

        private lazy var viewBackground: UIView = {
            return UIView()
        }()

        private lazy var lblTitle: UILabel = {
            let some = UIKitFactory.label(style: .notApplied)
            some.font = UIFont.App.Styles.headingSmall.rawValue
            some.textColor = UIColor.white
            return some
        }()

        private lazy var lblSpecification: UILabel = {
            let some = UIKitFactory.label(style: .notApplied)
            some.font = UIFont.App.Styles.paragraphMedium.rawValue
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
            let radius: CGFloat = 10
            disposeBag = DisposeBag()

            // Background
            addSubview(viewBackground)
            viewBackground.edgesToSuperview()
            viewBackground.backgroundColor = .clear
            viewBackground.addCorner(radius: radius)

            // Blur
            blurEffectView = viewBackground.addBlur()

            let cardView = UIView()
            addSubview(cardView)
            cardView.edgesToSuperview()
            cardView.addCorner(radius: radius)
            cardView.backgroundColor = UIColor.white.withAlphaComponent(FadeType.heavy.rawValue)

            // Title
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

            rxBtnBuyTap.bind { (_) in
                DevTools.Log.message("Tap")
                DevTools.makeToast("rxBtnBuyTap")
            }.disposed(by: disposeBag)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func applySecondaryStyle() {
            lblTitle.textColor = UIColor.black
            lblSpecification.textColor = lblTitle.textColor.withAlphaComponent(FadeType.regular.rawValue)
            viewBackground.backgroundColor = UIColor.white
            viewBackground.addShadow()

            // Blur
            blurEffectView.removeFromSuperview()

        }

        func setup(viewModel: VisionBox.ProductModel) {
            lblTitle.text = viewModel.name
            lblSpecification.text = "Specifications \(viewModel.specification) | Inventory \(viewModel.inventory)"
            lblPrice.text = viewModel.priceForCountry

        }
    }
}
