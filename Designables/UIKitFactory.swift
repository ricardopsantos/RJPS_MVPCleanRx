//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
import SkyFloatingLabelTextField
import Material
import Motion
//
import AppConstants
import AppTheme
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

public struct UIKitFactory {
    private init() {}

    public static func raisedButton(title: String,
                                    pulseColor: UIColor = UIColor.App.onPrimary,
                                    backgroundColor: UIColor = UIColor.App.primary) -> UIButton {
        let button = RaisedButton(title: title, titleColor: pulseColor)
        //button.
        button.pulseColor = pulseColor
        button.backgroundColor = backgroundColor
        button.addShadow()
        //button.apply(theme: Theme.dark)
        return button
    }

    public static func skyFloatingLabelTextField(title: String,
                                                 placeholder: String) -> SkyFloatingLabelTextField {
        let some = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 10, width: 120, height: 45))
        some.placeholder = placeholder
        some.title = title

        some.titleColor         = UIColor.App.UILabel.lblTextColor.withAlphaComponent(FadeType.regular.rawValue)
        some.selectedTitleColor = UIColor.App.UILabel.lblTextColor
        some.textColor          = UIColor.App.UILabel.lblTextColor

        some.errorColor      = UIColor.App.error
        some.titleErrorColor = UIColor.App.error
        some.textErrorColor  = UIColor.App.error
        some.lineErrorColor  = UIColor.App.error

        some.selectedLineColor = UIColor.App.primary
        some.lineColor         = UIColor.App.primary.withAlphaComponent(FadeType.regular.rawValue)
        some.tag = UIKitViewFactoryElementTag.textField.rawValue
        return some
    }

    public static func button(baseView: UIView? = nil,
                              title: String = "",
                              style: UIButton.LayoutStyle) -> UIButton {
        let some = UIButton()
        some.tag =  UIKitViewFactoryElementTag.button.rawValue
        some.setTitleForAllStates(title)
        some.layoutStyle = style
        baseView?.addSubview(some)
        return some
    }

    public static func textField(baseView: UIView? = nil,
                                 title: String = "") -> UITextField {
        let some = UITextField()
        some.text = title
        some.tag = UIKitViewFactoryElementTag.textField.rawValue
        baseView?.addSubview(some)
        return some
    }

    public static func labelWithPadding(padding: UIEdgeInsets? = nil,
                                        title: String = "",
                                        style: UILabel.LayoutStyle) -> UILabelWithPadding {
        let some = UILabelWithPadding(padding: padding, text: title)
        some.numberOfLines = 0
        some.tag =  UIKitViewFactoryElementTag.label.rawValue
        some.addShadow()
        some.layoutStyle = style
        return some
    }

    public static func label(baseView: UIView? = nil,
                             title: String = "",
                             style: UILabel.LayoutStyle) -> UILabel {
        let some = UILabel()
        some.text = title
        some.numberOfLines = 0
        some.tag =  UIKitViewFactoryElementTag.label.rawValue
        some.layoutStyle = style
        some.addShadow()
        baseView?.addSubview(some)
        return some
    }

    public static func scrollView() -> UIScrollView {
        let some = UIScrollView()
        some.tag = UIKitViewFactoryElementTag.scrollView.rawValue
        some.isUserInteractionEnabled = true
        some.isScrollEnabled = true
        some.autoresizesSubviews = false
        some.translatesAutoresizingMaskIntoConstraints = false
        return some
    }

    public static func searchBar(baseView: UIView? = nil, placeholder: String) -> CustomSearchBar {
        let some = CustomSearchBar()
        baseView?.addSubview(some)
        some.tintColor = UIColor.App.primary
        some.tag =  UIKitViewFactoryElementTag.searchBar.rawValue
        some.barStyle = .default

        let searchBarTextAttributes = [
            NSAttributedString.Key.font: UIFont.App.Styles.paragraphSmall.rawValue ,
            NSAttributedString.Key.foregroundColor: UIColor.App.UILabel.lblTextColor
        ]
        // Default attributes for search text
        UITextField.appearance(whenContainedInInstancesOf: [CustomSearchBar.self]).defaultTextAttributes = searchBarTextAttributes

        // Attributed placeholder string
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: searchBarTextAttributes)
        UITextField.appearance(whenContainedInInstancesOf: [CustomSearchBar.self]).attributedPlaceholder = attributedPlaceholder

        // Search bar cancel button
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [CustomSearchBar.self]).setTitleTextAttributes(searchBarTextAttributes, for: .normal)
        //UIBarButtonItem.appearance(whenContainedInInstancesOf: [CustomSearchBar.self]).title = "Cancel"

        return some
    }

    public static func switchWithCaption(caption: String,
                                         defaultValue: Bool = false,
                                         disposeBag: DisposeBag? = nil,
                                         toggle: ((Bool) -> Void)? = nil) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = AppSizes.Margins.defaultMargin
        let label = UILabel()
        label.font = UIFont.App.Styles.caption.rawValue 
        label.backgroundColor = .clear
        let uiSwitch = UISwitch()
        label.numberOfLines = 0
        label.apply(style: .value)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        label.text = caption
        uiSwitch.tintColor = UIColor.App.primary
        uiSwitch.isOn = defaultValue
        uiSwitch.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(uiSwitch)
        stackView.tag =  UIKitViewFactoryElementTag.searchBar.rawValue
        if let disposeBag = disposeBag, let toggle = toggle {
            uiSwitch.rx
                .isOn
                .changed
                .debounce(RxTimeInterval.milliseconds(800), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .asObservable()
                .log(whereAmI())
                .subscribe(onNext: { value in
                    toggle(value)
                }).disposed(by: disposeBag)
        }
        return stackView
    }

    public static func imageView(baseView: UIView? = nil,
                                 image: UIImage? = nil) -> UIImageView {
        let some = UIImageView()
        some.tag =  UIKitViewFactoryElementTag.imageView.rawValue
        if image != nil {
            some.image = image
        }
        baseView?.addSubview(some)
        return some
    }

    public static func tableView(baseView: UIView? = nil,
                                 cellIdentifier: String = AppConstants.Dev.cellIdentifier) -> UITableView {
        let some = UITableView()
        some.tag = UIKitViewFactoryElementTag.tableView.rawValue
        if !cellIdentifier.trim.isEmpty {
            some.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        }
        baseView?.addSubview(some)
        return some
    }

    // https://docs-assets.developer.apple.com/published/82128953f6/uistack_hero_2x_04e50947-5aa0-4403-825b-26ba4c1662bd.png
    // https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/LayoutUsingStackViews.html
    // https://spin.atomicobject.com/2016/06/22/uistackview-distribution/
    public static var stackViewDefaultLayoutMargins: UIEdgeInsets {
        let topAndBottomSpacing: CGFloat = 0 // Is [ZERO] because [stackViewDefaultSpacing] will do the vertical space (if vertical stackview)
        return UIEdgeInsets(top: topAndBottomSpacing,
                            left: Designables.Sizes.Margins.defaultMargin,
                            bottom: topAndBottomSpacing,
                            right: Designables.Sizes.Margins.defaultMargin)
    }
    public static var stackViewDefaultSpacing: CGFloat {
        return Designables.Sizes.Margins.defaultMargin / 2
    }
    public static func stackView(arrangedSubviews: [UIView] = [],
                                 spacing: CGFloat = UIKitFactory.stackViewDefaultSpacing, // Space between subviews
                                 axis: NSLayoutConstraint.Axis,
                                 distribution: UIStackView.Distribution = .fill,
                                 alignment: UIStackView.Alignment = .fill,
                                 layoutMargins: UIEdgeInsets? = UIKitFactory.stackViewDefaultLayoutMargins) -> UIStackView {
        // Distribution: Fill - makes one subview take up most of the space, while the others remain at their natural size.
        //               It decides which view to stretch by examining the content hugging priority for each of the subviews.
        // Distribution: Fill Equally - adjusts each subview so that it takes up equal amount of space in the stack view.
        //               All space will be used up.
        // Distribution: Equal Spacing - adjusts the spacing between subviews without resizing the subviews themselves.
        // Distribution: Equal Centring - attempts to ensure the centers of each subview are equally spaced, irrespective of how far the edge
        //               of each subview is positioned.
        // Distribution: Fill Proportionally - is the most interesting, because it ensures subviews remain the same size relative to each other,
        //               but still stretches them to fit the available space. For example, if one view is 100 across and another is 200, and the
        //               stack view decides to stretch them to take up more space, the first view might stretch to 150 and the other to 300
        //               – both going up by 50%.

        let some = UIStackView(arrangedSubviews: arrangedSubviews)
        some.tag     = UIKitViewFactoryElementTag.stackView.rawValue
        some.isLayoutMarginsRelativeArrangement = layoutMargins != nil
        if layoutMargins != nil {
            // When isLayoutMarginsRelativeArrangement property is true, the stack view will layout its arranged views relative to its layout margins.
            // Margins of the content views related to each other on the scroll view
            some.autoresizesSubviews = false
            some.layoutMargins = layoutMargins!
        }

        // Note
        some.axis         = axis         // determines the stack’s orientation, either vertically or horizontally.
        some.distribution = distribution // determines the layout of the arranged views along the stack’s axis.
        some.spacing      = spacing      // determines the minimum spacing between arranged views.
        some.alignment    = alignment    // determines the layout of the arranged views perpendicular to the stack’s axis.
        return some
    }
    
    public static func topBar(baseController: UIViewController, usingSafeArea: Bool) -> TopBar {
        let bar = TopBar()
        bar.injectOn(viewController: baseController, usingSafeArea: usingSafeArea)
        return bar
    }

    public static func bottomBar(baseController: UIViewController, usingSafeArea: Bool) -> BottomBar {
        let bar = BottomBar()
        bar.injectOn(viewController: baseController, usingSafeArea: usingSafeArea)
        return bar
    }
}
