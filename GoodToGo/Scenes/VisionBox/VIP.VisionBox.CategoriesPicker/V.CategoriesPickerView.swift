//
//  V.CategoriesPickerView.swift
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
struct CategoriesPickerView_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.CategoriesPickerView, context: Context) { }
    func makeUIView(context: Context) -> V.CategoriesPickerView {
        let some = V.CategoriesPickerView()
        return some
    }
}

@available(iOS 13.0.0, *)
struct CategoriesPickerView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        CategoriesPickerView_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class CategoriesPickerView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        var rxCategoryTap = BehaviorSubject<VisionBox.Category?>(value: nil)

        private lazy var b1: CategoryButton = { V.CategoryButton(category: .cat1) }()
        private lazy var b2: CategoryButton = { V.CategoryButton(category: .cat2) }()
        private lazy var b3: CategoryButton = { V.CategoryButton(category: .cat3) }()
        private lazy var b4: CategoryButton = { V.CategoryButton(category: .cat4) }()
        private lazy var b5: CategoryButton = { V.CategoryButton(category: .cat5) }()
        private lazy var b6: CategoryButton = { V.CategoryButton(category: .cat6) }()
        private lazy var b7: CategoryButton = { V.CategoryButton(category: .cat7) }()
        private lazy var b8: CategoryButton = { V.CategoryButton(category: .cat8) }()
        private lazy var b9: CategoryButton = { V.CategoryButton(category: .cat9) }()

        private lazy var lblTitle: UILabel = { UIKitFactory.label(style: .notApplied) }()
        
        // MARK: - Mandatory

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(lblTitle)
            [b1, b2, b3, b4, b5, b6, b7, b8, b9].forEach { (some) in
                self.addSubview(some)
            }
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            let marginH = (screenWidth - V.CategoryButton.defaultSize * 3) / 4

            lblTitle.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            lblTitle.autoLayout.leftToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)
            lblTitle.autoLayout.topToSuperview(usingSafeArea: true)

            [b1, b2, b3, b4, b5, b6, b7, b8, b9].forEach { (some) in
                some.autoLayout.width(V.CategoryButton.defaultSize)
                some.autoLayout.height(V.CategoryButton.defaultSize)
            }

            [b1, b2, b3].forEach { (some) in
                //some.autoLayout.topToBottom(of: lblTitle, offset: marginH)
                some.autoLayout.bottomToTop(of: b5, offset: -marginH)
            }

            [b2, b5, b8].forEach { (some) in
                some.autoLayout.centerXToSuperview()
            }

            [b4, b5, b6].forEach { (some) in
                some.autoLayout.centerYToSuperview()
            }

            [b6, b3, b9].forEach { (some) in
                some.autoLayout.trailingToSuperview(offset: marginH)
            }

            [b1, b4, b7].forEach { (some) in
                  some.autoLayout.leadingToSuperview(offset: marginH)
              }

            [b7, b8, b9].forEach { (some) in
                //some.bottomToSuperview(offset: -marginH)
                some.autoLayout.topToBottom(of: b5, offset: marginH)

            }

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            lblTitle.textAlignment = .left
            lblTitle.font = UIFont.App.Styles.headingBold.rawValue
            lblTitle.text = "Select a category"
            //DevTools.DebugView.paint(view: self, method: 1)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

            [b1, b2, b3, b4, b5, b6, b7, b8, b9].forEach { (some) in
                let tapGesture = UITapGestureRecognizer()
                some.addGestureRecognizer(tapGesture)
                tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
                    guard let self = self else { return }
                    (recognizer.view as? CategoryButton)?.layoutColorsForPressed()
                    let category = VisionBox.Category(rawValue: recognizer.view!.tag)
                    self.rxCategoryTap.onNext(category)
                }).disposed(by: disposeBag)
            }
        }

        // MARK: - Custom Getter/Setters

        func setupWith(someStuff viewModel: VM.CategoriesPicker.CategoryChange.ViewModel) {

        }

        func setupWith(screenInitialState viewModel: VM.CategoriesPicker.ScreenInitialState.ViewModel) {

        }
    }
}

// MARK: - Events capture

extension V.CategoriesPickerView {

}

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
