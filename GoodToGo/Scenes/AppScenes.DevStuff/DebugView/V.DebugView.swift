//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

// swiftlint:disable all

import UIKit
import Foundation
import SwiftUI
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
import RJSLibUFBase
import RJSLibUFAppThemes
//
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import BaseUI
import AppResources

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}

// MARK: - Preview

@available(iOS 13.0.0, *)
struct DebugView_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.DebugView, context: Context) { }
    func makeUIView(context: Context) -> V.DebugView {
        let some = V.DebugView()
        return some
    }
}

@available(iOS 13.0.0, *)
struct DebugView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        DebugView_UIViewRepresentable()
    }
}

// MARK: - View

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

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(stackViewVLevel1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()

            let sectionSize: CGFloat = 3
            let sectionSmallSeparatorColor = ComponentColor.primary.withAlphaComponent(FadeType.superLight.rawValue)
            func buttonWithAction(title: String, block:@escaping () -> Void) -> UIButton {
                let some = UIKitFactory.raisedButton(title: title, backgroundColor: ComponentColor.primary)
                some.onTouchUpInside {
                    block()
                }
                return some
            }

            func makeSection(_ name: String, size: CGFloat) {
                stackViewVLevel1.uiUtils.addArrangedSeparator()
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: size, color: UIColor.lightGray)
                let label = UILabel()
                label.text = name
                label.font = AppFonts.Styles.headingSmall.rawValue
                label.textAlignment = .center
                label.textColor = ComponentColor.primary
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(label)
                stackViewVLevel1.uiUtils.addArrangedSeparator()
            }

            func pureLabel(text: String) -> UILabel {
                let label = UIKitFactory.label(style: .title)
                label.text = text
                label.textAlignment = .center
                label.font = AppFonts.Styles.caption.rawValue 
                return label
            }

            let testBackgroundColors = [UIColor.white, ComponentColor.primary]

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
                    self.displayMessage(randomStringWith(length: randomInt(min: 50, max: 100)), type: some)
                }
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(button)
                button.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            }

            //
            // UILabel.LayoutStyle
            //

            makeSection("UILabel.LayoutStyle", size: sectionSize)

            RJS_LabelStyle.allCases.forEach { (some) in
                testBackgroundColors.forEach { (backgroundColor) in
                    let some = UIKitFactory.label(title: "\(some)", style: some)
                    some.backgroundColor = backgroundColor.withAlphaComponent(FadeType.superHeavy.rawValue)
                    some.textAlignment = .center
                    some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                    stackViewVLevel1.uiUtils.safeAddArrangedSubview(some)
                }
                let some = UIKitFactory.label(title: "\(some)", style: some)
                some.backgroundColor = some.textColor.inverse.withAlphaComponent(FadeType.superHeavy.rawValue)
                some.textAlignment = .center
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(some)
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // UIButton.LayoutStyle
            //

            makeSection("UIButton.LayoutStyle", size: sectionSize)
            
            RJS_ButtontStyle.allCases.forEach { (some) in
                let btn = UIKitFactory.button(title: "\(some)", style: some)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(btn)
                btn.rx.tapSmart(disposeBag).asObservable().subscribe { (_) in
                    print("tap")
                }.disposed(by: disposeBag)
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
                view.backgroundColor = ComponentColor.primary.withAlphaComponent(some.rawValue)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(view)
                view.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                //stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // Components
            //

            makeSection("Components", size: sectionSize)

            let labelWithPadding = UIKitFactory.labelWithPadding(title: "labelWithPadding", style: .title)
            labelWithPadding.backgroundColor = ComponentColor.primary.withAlphaComponent(FadeType.heavy.rawValue)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(labelWithPadding)

            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

            let raisedButton = UIKitFactory.raisedButton(title: "raisedButton", backgroundColor: ComponentColor.primary)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(raisedButton)

            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

            let skyFloatingLabelTextField = UIKitFactory.skyFloatingLabelTextField(title: "skyFloatingLabelTextField",
                                                                                   placeholder: "Your skyFloatingLabelTextField")
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(skyFloatingLabelTextField)

            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

            stackViewVLevel1.uiUtils.addArrangedSeparator()

            //
            // AppFonts.Alternative
            //

            makeSection("AppFonts.Alternative", size: sectionSize)
            let allFonts = AppFonts.Styles.allCases
            let allFontsSorted = allFonts.sorted { (f1, f2) -> Bool in return f1.rawValue.pointSize > f2.rawValue.pointSize }
            allFontsSorted.forEach { (font) in
                let some1 = UILabel()
                some1.text = "\(font)"
                some1.font = font.rawValue
                some1.textAlignment = .center
                some1.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                let some2 = UILabel()
                some2.text = "\(font.rawValue.fontName) \(font.rawValue.pointSize)"
                some2.font = AppFonts.Styles.caption.rawValue
                some2.textAlignment = .center
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(some1)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(some2)
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // UIColor.Pack1
            //

            makeSection("UIColor.Pack1", size: sectionSize)
            UIColor.Pack1.allCases.forEach { (some) in
                let view = UILabel()
                view.text = "\(some)"
                view.apply(style: .value)
                view.textColor = some.color.inverse
                view.backgroundColor = some.color
                view.textAlignment = .center
                view.addCorner(radius: 1)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(view)
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            //
            // UIColor.Pack2
            //

            makeSection("UIColor.Pack2", size: sectionSize)
            UIColor.Pack2.allCases.forEach { (some) in
                let view = UILabel()
                view.text = "\(some)"
                view.apply(style: .value)
                view.textColor = some.color.inverse
                view.backgroundColor = some.color
                view.textAlignment = .center
                view.addCorner(radius: 1)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(view)
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            stackViewVLevel1.uiUtils.addArrangedSeparator()

            //
            // UIColor.Pack3 / ColorName
            //

            makeSection("UIColor.Pack3/ColorName", size: sectionSize)
            UIColor.Pack3.allCases.forEach { (some) in
                let view = UILabel()
                view.text = "\(some)"
                view.apply(style: .value)
                view.textColor = some.color.inverse
                view.backgroundColor = some.color
                view.textAlignment = .center
                view.addCorner(radius: 1)
                stackViewVLevel1.uiUtils.safeAddArrangedSubview(view)
                stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
            }

            stackViewVLevel1.uiUtils.addArrangedSeparator()
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()

            let topBarSize    = TopBar.defaultHeight(usingSafeArea: false)
            let bottomBarSize: CGFloat = 0//BottomBar.backgroundHeight
            scrollView.autoLayout.trailingToSuperview()
            scrollView.autoLayout.leftToSuperview()
            scrollView.autoLayout.topToSuperview(offset: topBarSize, usingSafeArea: false)
            scrollView.autoLayout.height(screenHeight - topBarSize  - bottomBarSize - AppleSizes.tabBarControllerDefaultSize)

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {

        }

        override func setupColorsAndStyles() {
            self.backgroundColor = ColorName.background.color
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

    }
}

// MARK: - Events capture

extension V.DebugView {

}
