//
//  UI.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import AppConstants
import AppTheme
import DevTools
import Extensions
import Designables
import UIBase
import PointFreeFunctions
import RJPSLib

// MARK: - MoeyProgramaticUIUtilsCompatible

public protocol MoeyProgramaticUIUtilsCompatible {
    associatedtype T
    var I9UI: T { get }
}

public extension MoeyProgramaticUIUtilsCompatible {
    var I9UI: MoeyProgramaticUIUtils<Self> { return MoeyProgramaticUIUtils(self) }
}

public struct MoeyProgramaticUIUtils<MoeyBase> {
    let base: MoeyBase
    init(_ base: MoeyBase) {
        self.base = base
    }
}

extension UIView: MoeyProgramaticUIUtilsCompatible { }

// MARK: - UIScrollView Utils

public extension MoeyProgramaticUIUtils where MoeyBase: UIScrollView {

    func edgeScrollViewToSuperView() {
        let target = self.base
        target.edgesToSuperview()
        if #available(iOS 11.0, *) {
            target.contentInsetAdjustmentBehavior = .always
        }
        target.autoLayout.width(to: target.superview!) // NEEDS THIS!
    }

    // Solving the issue : uiscrollview scrollable content size ambiguity
    // https://stackoverflow.com/questions/19036228/uiscrollview-scrollable-content-size-ambiguity
    func addContentView() -> UIView {
        let target = self.base
        let contentView: UIView = UIView()
        target.addSubview(contentView)
        contentView.autoLayout.edgesToSuperview()
        guard let superview = target.superview else {
            assert(false, message: "Superview is nil")
            return contentView
        }
        contentView.autoLayout.size(to: superview)
        return contentView
    }

    func addStackView(_ statckView: UIStackView) {
        let target = self.base
        let contentView = target.I9UI.addContentView()
        contentView.addSubview(statckView)
        statckView.I9UI.edgeStackViewToSuperView()
    }
}

// MARK: - StackView Utils

public extension MoeyProgramaticUIUtils where MoeyBase: UIStackView {

    func edgeStackViewToSuperView() {
        let target = self.base
        guard target.superview != nil else {
            print("MoeyProgramaticUIUtils - edgeStackViewToSuperView : No super view for [\(target)]")
            return
        }
        target.autoLayout.edgesToSuperview() // Don't use RJPSLayouts. It will fail if scroll view is inside of stack view with lots of elements
        target.autoLayout.width(to: target.superview!) // NEEDS THIS!
    }

    // If value=0, will use as separator size will (look) be twice the current
    // stack view separator (trust me)
    @discardableResult
    func addArrangedSeparator(withSize value: CGFloat=0, color: UIColor = .clear, tag: Int? = nil) -> UIView {
        let target = self.base
        let separator = UIView()
        separator.backgroundColor = color
        if tag != nil {
            separator.tag = tag!
        } else {
            separator.tag = UIKitViewFactoryElementTag.stackViewSpace.rawValue
        }
        target.addArrangedSubview(separator)
        var finalValue = value
        if finalValue == 0 && target.spacing == 0 {
            // No space passed, and the stack view does not have space? Lets force a space
            finalValue = 10
        }
        if target.axis == .horizontal {
            separator.autoLayout.width(finalValue)
        } else {
            separator.autoLayout.height(finalValue)
        }
        return separator
    }

    func safeRemove(_ view: UIView) {
        let viewExists = view.superview != nil
        if viewExists {
            view.removeFromSuperview()
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    @discardableResult
    func safeAddArrangedSubview(_ view: UIView) -> Bool {
        let target = self.base
        let viewExists = view.superview != nil
        if !viewExists {
            target.addArrangedSubview(view)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        return !viewExists
    }

    func safeAddArrangedSubviews(_ views: [UIView]) {
        views.forEach { (some) in
            safeAddArrangedSubview(some)
        }
    }
}

public extension MoeyProgramaticUIUtils where MoeyBase: UIImageView {

    func setImage(_ image: UIImage, with color: UIColor) {
        let target = self.base
        target.image = image
        target.backgroundColor = UIColor.clear
        target.changeImageColor(to: color)
    }

    func changeImageColor(to color: UIColor) {
        let target = self.base
        target.changeImageColor(to: color)
    }

}

// MARK: - UIView Utils

public extension MoeyProgramaticUIUtils where MoeyBase: UIView {

    func setVisibilityToState(_ value: Bool) {
        let target = self.base
        target.isUserInteractionEnabled = value ? true : false
        target.alpha = value ? 1 : 0
        target.subviews.forEach { (some) in
            some.alpha = value ? 1 : 0
        }
    }

    func addShadow(shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat) {
        let target = self.base
        target.layer.shadowColor = shadowColor.cgColor
        target.layer.shadowOpacity = 1
        target.layer.shadowOffset = shadowOffset
        target.layer.shadowRadius = shadowRadius
        target.layer.masksToBounds = false
    }

    func setWidthAnchor(value: CGFloat) {
        let target = self.base
        target.translatesAutoresizingMaskIntoConstraints = false
        target.widthAnchor.constraint(equalToConstant: value).isActive = true
    }

    func setHeightAnchor(value: CGFloat) {
        let target = self.base
        target.translatesAutoresizingMaskIntoConstraints = false
        target.heightAnchor.constraint(equalToConstant: value).isActive = true
    }

}
