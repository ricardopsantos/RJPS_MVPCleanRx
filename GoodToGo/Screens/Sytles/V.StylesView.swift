//
//  V.StylesView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

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

//
// INSERT INVISION/ZEPLIN RELATED LAYOUT SCREENS BELOW
//
// Colors WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/378/Colors
// Labels WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/880/Typography
// Icons WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/333/Icons
//

extension V {
    class StylesView: BaseGenericViewVIP {

        deinit {

        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var scrollView: UIScrollView = {
            UIKitFactory.scrollView()
        }()

        private lazy var stackViewVLevel1: UIStackView = {
            UIKitFactory.stackView(axis: .vertical)
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(stackViewVLevel1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()

            func buttonWithAction(title: String, block:@escaping () -> Void) -> UIButton {
                let some = UIKitFactory.button(title: title, style: .regular)
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

            //
            // FeatureFlag
            //

            makeSection("DevTools.FeatureFlag", size: 5)
            func makeFeatureView(_ flag: DevTools.FeatureFlag) -> UIView {
                let view = UIKitFactory.switchWithCaption(caption: flag.rawValue,
                                                          defaultValue: flag.defaultValue,
                                                          disposeBag: disposeBag) { value in
                                                            DevTools.FeatureFlag.setFlag(flag, value: value)
                }
                if flag.rawValue.lowercased().hasPrefix("dev") {
                    // On real devices, Dev features are faded
                    view.alpha = Designables.Constants.disabledViewAlpha
                }
                return view
            }
            let ffViews: [UIView] = DevTools.FeatureFlag.allCases.map { makeFeatureView($0) }
            ffViews.forEach { (ffView) in
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(ffView)
                stackViewVLevel1.uiUtils.addArrangedSeparator()
            }

            //
            // AlertType
            //

            makeSection("AlertType", size: 5)

            AlertType.allCases.forEach { (some) in
                let button = buttonWithAction(title: "Alert.\(some)") {
                    BaseViewControllerMVP.shared.displayMessage(randomStringWith(length: randomInt(min: 50, max: 100)), type: some)
                }
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(button)
                stackViewVLevel1.uiUtils.addArrangedSeparator()
            }

            //
            // UILabel.LayoutStyle
            //

            makeSection("UILabel.LayoutStyle", size: 5)

            UILabel.LayoutStyle.allCases.forEach { (some) in
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(UIKitFactory.label(title: "\(some)", style: some))
                stackViewVLevel1.uiUtils.addArrangedSeparator()
            }

            //
            // UILabel.LayoutStyle
            //

            makeSection("UIButton.LayoutStyle", size: 5)
            
            UIButton.LayoutStyle.allCases.forEach { (some) in
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(UIKitFactory.button(title: "\(some)", style: some))
                stackViewVLevel1.uiUtils.addArrangedSeparator()
            }

            //
            // Components
            //

            makeSection("Components", size: 5)

            let labelWithPadding = UILabelWithPadding()
            labelWithPadding.text = "UILabelWithPadding"
            labelWithPadding.label.apply(style: .title)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(labelWithPadding)

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(screenHeight)
/*
            self.subViewsOf(types: [.button, .label], recursive: true).forEach { (some) in
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                some.autoLayout.marginToSuperVerticalStackView(trailing: defaultMargin, leading: defaultMargin)
            }
*/
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {

        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.appDefaultBackgroundColor
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

extension V.StylesView {

}
