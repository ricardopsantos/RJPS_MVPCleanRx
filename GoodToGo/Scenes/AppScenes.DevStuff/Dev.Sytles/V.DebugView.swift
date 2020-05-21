//
//  V.StylesView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

// swiftlint:disable all

import UIKit
import Foundation
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

extension V {
    class DebugView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var scrollView: UIScrollView = {
            UIKitFactory.scrollView()
        }()

        private lazy var stackViewVLevel1: UIStackView = {
            UIKitFactory.stackView(axis: .vertical)        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(stackViewVLevel1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()

            let sectionSize: CGFloat = 3
            let sectionSmallSeparatorColor = AppColors.primary.withAlphaComponent(FadeType.superLight.rawValue)
            func buttonWithAction(title: String, block:@escaping () -> Void) -> UIButton {
                let some = UIKitFactory.raisedButton(title: title, backgroundColor: AppColors.primary)
                //let some = UIKitFactory.button(title: title, style: .regular)
                some.onTouchUpInside {
                    block()
                }
                return some
            }

            func makeSection(_ name: String, size: CGFloat) {
                stackViewVLevel1.uiUtils.addArrangedSeparator()
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: size, color: UIColor.lightGray)
                let label = UIKitFactory.label(title: "\(name)", style: .title)
                label.textAlignment = .center
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(label)
                stackViewVLevel1.uiUtils.addArrangedSeparator()
            }

            func pureLabel(text: String) -> UILabel {
                let label = UIKitFactory.label(style: .title)
                label.text = text
                label.textAlignment = .center
                label.font = UIFont.App.bold(size: .regular)
                return label
            }

            let testBackgroundColors = [UIColor.white, UIColor.App.primary, UIColor.black]

            //
            // FeatureFlag
            //

            makeSection("DevTools.FeatureFlag", size: sectionSize)
            func makeFeatureView(_ flag: DevTools.FeatureFlag) -> UIView {
                let view = UIKitFactory.switchWithCaption(caption: flag.rawValue,
                                                          defaultValue: flag.isTrue,
                                                          disposeBag: disposeBag) { value in
                                                            DevTools.FeatureFlag.setFlag(flag, value: value)
                }
                return view
            }
            let ffViews: [UIView] = DevTools.FeatureFlag.allCases.filter({ $0.isVisible }).map { makeFeatureView($0) }
            ffViews.forEach { (ffView) in
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(ffView)
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // AlertType
            //

            makeSection("AlertType", size: sectionSize)

            AlertType.allCases.forEach { (some) in
                let button = buttonWithAction(title: "Tap to show \(some) alert") {
                    BaseViewControllerMVP.shared.displayMessage(randomStringWith(length: randomInt(min: 50, max: 100)), type: some)
                }
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(button)
                button.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            }

            //
            // UILabel.LayoutStyle
            //

            makeSection("UILabel.LayoutStyle", size: sectionSize)

            UILabel.LayoutStyle.allCases.forEach { (some) in
                testBackgroundColors.forEach { (backgroundColor) in
                    let some = UIKitFactory.label(title: "\(some)", style: some)
                    some.backgroundColor = backgroundColor
                    some.textAlignment = .center
                    some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                    stackViewVLevel1.uiUtils.safeAddArrangedSubview(some)
                }
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // UIButton.LayoutStyle
            //

            makeSection("UIButton.LayoutStyle", size: sectionSize)
            
            UIButton.LayoutStyle.allCases.forEach { (some) in
                let btn = UIKitFactory.button(title: "\(some)", style: some)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(btn)
                btn.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                //stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // Shadows
            //

            makeSection("Shadows", size: sectionSize)
            ShadowType.allCases.forEach { (some) in
                testBackgroundColors.forEach { (backgroundColor) in
                    let view = pureLabel(text: "\(some)")
                    view.backgroundColor = backgroundColor
                    view.textAlignment = .center
                    view.addShadow(shadowType: some)
                    view.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                    stackViewVLevel1.uiUtils.safeAddArrangedSubview(view)
                }
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // FadeType
            //

            makeSection("FadeType", size: sectionSize)
            FadeType.allCases.forEach { (some) in
                let view = pureLabel(text: "\(some)")
                view.backgroundColor = UIColor.App.primary.withAlphaComponent(some.rawValue)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(view)
                view.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                //stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // Components
            //

            makeSection("Components", size: sectionSize)

            let labelWithPadding = UIKitFactory.labelWithPadding(title: "labelWithPadding", style: .title)
            labelWithPadding.backgroundColor = UIColor.App.primary.withAlphaComponent(FadeType.heavy.rawValue)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(labelWithPadding)

            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

            let raisedButton = UIKitFactory.raisedButton(title: "raisedButton", backgroundColor: AppColors.primary)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(raisedButton)

            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

            let skyFloatingLabelTextField = UIKitFactory.skyFloatingLabelTextField(title: "skyFloatingLabelTextField",
                                                                                   placeholder: "Your skyFloatingLabelTextField")
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(skyFloatingLabelTextField)

            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.addArrangedSeparator()

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()

            if false {
                scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
                scrollView.autoLayout.height(screenHeight - BottomBar.backgroundHeight - AppleSizes.tabBarControllerDefaultSize)
            } else {
                let topBarSize    = TopBar.defaultHeight(usingSafeArea: false)
                let bottomBarSize = BottomBar.backgroundHeight
                scrollView.autoLayout.trailingToSuperview()
                scrollView.autoLayout.leftToSuperview()
                scrollView.autoLayout.topToSuperview(offset: topBarSize, usingSafeArea: false)
                scrollView.autoLayout.height(screenHeight - topBarSize  - bottomBarSize - AppleSizes.tabBarControllerDefaultSize)
            }

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {

        }

        override func setupColorsAndStyles() {
            self.backgroundColor = UIColor.white // mais facil para ver os filtros
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

    }
}

// MARK: - Events capture

extension V.DebugView {

}
