//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
        let button = RaisedButton(title: title, titleColor: .white)
        button.pulseColor = UIColor.App.onPrimary //.white
        button.backgroundColor = backgroundColor
        return button
    }

    public static func skyFloatingLabelTextField(title: String,
                                                 placeholder: String) -> SkyFloatingLabelTextField {
        let some = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 10, width: 120, height: 45))
        some.placeholder = placeholder
        some.title = title
        some.errorColor = UIColor.App.error
        some.titleColor = UIColor.App.lblTextColor
        some.textColor = UIColor.App.lblTextColor
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

    public static func labelWithPadding(title: String = "",
                                        style: UILabel.LayoutStyle) -> UILabelWithPadding {
        let some = UILabelWithPadding()
        some.text = title
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
            NSAttributedString.Key.font: UIFont.App.regular(size: .regularBig),
            NSAttributedString.Key.foregroundColor: UIColor.App.lblTextColor
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
        label.font = UIFont.App.bold(size: .big)
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
        let topAndBottomSpacing: CGFloat = 0 // Is [ZERO] because [stackViewDefaultSpacing] will do the vertical space (if vertical stack-view)
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
        // Distribution: Equal Centering - attempts to ensure the centers of each subview are equally spaced, irrespective of how far the edge
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
    
    public static func topBar(baseController: UIViewController) -> TopBar {
        let bar = TopBar()
        bar.injectOn(viewController: baseController)
        /*
         let screenWidth = UIScreen.main.bounds.width
         let height      = TopBar.defaultHeight
         let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
         baseController.view.addSubview(container)
         UIViewController.rjs.loadViewControllerInContainedView(sender: baseController,
         senderContainedView: container,
         controller: bar) { (_, _) in }

         container.rjsALayouts.setMargin(0, on: .top)
         container.rjsALayouts.setMargin(0, on: .right)
         container.rjsALayouts.setMargin(0, on: .left)
         container.rjsALayouts.setHeight(TopBar.defaultHeight)

         bar.view.rjsALayouts.setMargin(0, on: .top)
         bar.view.rjsALayouts.setMargin(0, on: .right)
         bar.view.rjsALayouts.setMargin(0, on: .left)
         bar.view.rjsALayouts.setHeight(TopBar.defaultHeight)
         return bar*/
        return bar
    }

    public static func bottomBar(baseController: UIViewController) -> BottomBar {
        let bar         = BottomBar()
        bar.view.backgroundColor = .clear
        let screenWidth = UIScreen.main.bounds.width
        let height      = TopBar.defaultHeight
        let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
        baseController.view.addSubview(container)
        UIViewController.rjs.loadViewControllerInContainedView(sender: baseController, senderContainedView: container, controller: bar) { (_, _) in }

        container.rjsALayouts.setMargin(0, on: .bottom)
        container.rjsALayouts.setMargin(0, on: .right)
        container.rjsALayouts.setMargin(0, on: .left)
        container.rjsALayouts.setHeight(BottomBar.defaultHeight())
        container.backgroundColor = .clear

        bar.view.rjsALayouts.setMargin(0, on: .top)
        bar.view.rjsALayouts.setMargin(0, on: .right)
        bar.view.rjsALayouts.setMargin(0, on: .left)
        bar.view.rjsALayouts.setHeight(BottomBar.defaultHeight())
        return bar
    }
}
