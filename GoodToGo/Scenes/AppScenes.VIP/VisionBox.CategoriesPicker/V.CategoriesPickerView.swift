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
        some.title = "Hi"
        return some
    }
}

@available(iOS 13.0.0, *)
struct CategoriesPickerView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        CategoriesPickerView_UIViewRepresentable()
    }
}

extension V {

    open class CategoryButton: UIView {
        static let defaultSize: CGFloat = screenWidth / 4.0
        private let label = UILabel()
        private let back = UIView()
        private let image = UIImageView()

        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        public convenience init(text: String="", imageSystemName: String) {
            self.init(frame: .zero)
            label.text = text
            if #available(iOS 13.0, *) {
                image.image = UIImage(systemName: imageSystemName)
            }
        }

        open override func layoutSubviews() {
            super.layoutSubviews()
        }

        private func setupView() {
            addSubview(back)
            addSubview(image)
            addSubview(label)

            label.autoLayout.bottomToSuperview()
            label.autoLayout.widthToSuperview()
            label.textAlignment = .center
            label.apply(style: .title)

            back.addCorner(radius: 10)
            back.autoLayout.centerXToSuperview()
            back.autoLayout.centerYToSuperview(offset: -10)
            back.autoLayout.widthToSuperview(multiplier: 0.6)
            back.autoLayout.heightToSuperview(multiplier: 0.6)
            back.backgroundColor = .red

            image.autoLayout.centerXToSuperview()
            image.autoLayout.centerYToSuperview(offset: -10)
            image.autoLayout.widthToSuperview(multiplier: 0.5)
            image.autoLayout.heightToSuperview(multiplier: 0.5)
            image.contentMode = .scaleAspectFit
            image.backgroundColor = .clear
            
            self.backgroundColor = UIColor.blue.withAlphaComponent(0.1)

        }
    }

}

// MARK: - View

extension V {
    class CategoriesPickerView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var stackViewVLevel1: UIStackView = {
            UIKitFactory.stackView(axis: .vertical, alignment: .fill, layoutMargins: nil)
        }()

        func makeVerticalStackView() -> UIStackView {
            let stackView = UIKitFactory.stackView(axis: .horizontal, distribution: .fillEqually)
            let b1 = V.CategoryButton(text: "1", imageSystemName: "trash.fill")
            let b2 = V.CategoryButton(text: "1", imageSystemName: "trash.fill")
            let b3 = V.CategoryButton(text: "1", imageSystemName: "trash.fill")
            stackView.addArrangedSubview(b1)
            stackView.addArrangedSubview(b2)
            stackView.addArrangedSubview(b3)
            b1.autoLayout.width(screenWidth / 5)
            b2.autoLayout.width(screenWidth / 5)
            b3.autoLayout.width(screenWidth / 5)
            b1.autoLayout.height(screenWidth / 5)
            b2.autoLayout.height(screenWidth / 5)
            b3.autoLayout.height(screenWidth / 5)
            return stackView
        }

        var verticalStackView1: UIStackView!
        var verticalStackView2: UIStackView!
        var verticalStackView3: UIStackView!

        private lazy var lblTitle: UILabel = {
            UIKitFactory.label(style: .value)
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(stackViewVLevel1)

            verticalStackView1 = makeVerticalStackView()
            verticalStackView2 = makeVerticalStackView()
            verticalStackView3 = makeVerticalStackView()

            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblTitle)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(verticalStackView1)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(verticalStackView2)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(verticalStackView3)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            let defaultMargin = Designables.Sizes.Margins.defaultMargin

            stackViewVLevel1.autoLayout.widthToSuperview()
            stackViewVLevel1.autoLayout.topToSuperview()
            //stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            verticalStackView1.autoLayout.widthToSuperview()
            verticalStackView2.autoLayout.widthToSuperview()
            verticalStackView3.autoLayout.widthToSuperview()
            //scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            //scrollView.autoLayout.height(scrollViewHeight)

            self.subViewsOf(types: [.label], recursive: true).forEach { (some) in
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                some.autoLayout.widthToSuperview()
                some.autoLayout.marginToSuperVerticalStackView(trailing: defaultMargin, leading: defaultMargin)
            }

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            lblTitle.textAlignment = .center
            DevTools.DebugView.paint(view: self, useBorderColors: true)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        public var title: String {
            get { return  lblTitle.text ?? "" }
            set(newValue) {
                lblTitle.textAnimated = newValue
            }
        }

        public var titleStyleType: UILabel.LayoutStyle = .value {
            didSet {
                lblTitle.layoutStyle = titleStyleType
            }
        }

        func setupWith(someStuff viewModel: VM.CategoriesPicker.Something.ViewModel) {
            title = viewModel.subTitle
        }

        func setupWith(screenInitialState viewModel: VM.CategoriesPicker.ScreenInitialState.ViewModel) {
            title = viewModel.subTitle
            screenLayout = viewModel.screenLayout
        }

        var screenLayout: E.CategoriesPickerView.ScreenLayout = .layoutA {
            didSet {
                // show or hide stuff
            }
        }
    }
}

// MARK: - Events capture

extension V.CategoriesPickerView {
    //var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    //var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    //var rxModelSelected: ControlEvent<VM.CategoriesPicker.TableItem> {
    //    tableView.rx.modelSelected(VM.CategoriesPicker.TableItem.self)
    //}
}
