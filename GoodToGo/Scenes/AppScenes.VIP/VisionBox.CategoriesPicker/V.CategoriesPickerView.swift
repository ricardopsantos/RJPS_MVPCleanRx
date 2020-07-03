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

        private let b1 = V.CategoryButton(text: "1", imageSystemName: "trash.fill")
        private let b2 = V.CategoryButton(text: "2", imageSystemName: "trash.fill")
        private let b3 = V.CategoryButton(text: "3", imageSystemName: "trash.fill")
        private let b4 = V.CategoryButton(text: "4", imageSystemName: "trash.fill")
        private let b5 = V.CategoryButton(text: "5", imageSystemName: "trash.fill")
        private let b6 = V.CategoryButton(text: "6", imageSystemName: "trash.fill")
        private let b7 = V.CategoryButton(text: "7", imageSystemName: "trash.fill")
        private let b8 = V.CategoryButton(text: "8", imageSystemName: "trash.fill")
        private let b9 = V.CategoryButton(text: "9", imageSystemName: "trash.fill")

        private lazy var lblTitle: UILabel = {
            UIKitFactory.label(style: .value)
        }()

        private lazy var searchBar: CustomSearchBar = {
            return UIKitFactory.searchBar(placeholder: Messages.search.localised)
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(searchBar)
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

            searchBar.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            searchBar.autoLayout.widthToSuperview()
            searchBar.autoLayout.topToSuperview()

            lblTitle.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            lblTitle.autoLayout.widthToSuperview()
            lblTitle.autoLayout.topToBottom(of: searchBar, offset: marginH)

            [b1, b2, b3, b4, b5, b6, b7, b8, b9].forEach { (some) in
                some.autoLayout.width(V.CategoryButton.defaultSize)
                some.autoLayout.height(V.CategoryButton.defaultSize)
            }

            [b1, b2, b3].forEach { (some) in
                some.autoLayout.topToBottom(of: lblTitle, offset: marginH)
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
                some.bottomToSuperview(offset: -marginH)
            }

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            lblTitle.textAlignment = .center
            lblTitle.text = "123123"
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
