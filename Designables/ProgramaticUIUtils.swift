//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import TinyConstraints
//
import BaseConstants
import DevTools
import Extensions
import PointFreeFunctions
import AppTheme

// MARK: - GoodToGoProgramaticUIUtilsCompatible

public protocol GoodToGoProgramaticUIUtilsCompatible {
    associatedtype T
    var uiUtils: T { get }
}

public extension GoodToGoProgramaticUIUtilsCompatible {
    var uiUtils: GoodToGoProgramaticUIUtils<Self> { return GoodToGoProgramaticUIUtils(self) }
}

public struct GoodToGoProgramaticUIUtils<GoodToGoBase> {
    let base: GoodToGoBase
    init(_ base: GoodToGoBase) {
        self.base = base
    }
}

extension UIView: GoodToGoProgramaticUIUtilsCompatible { }

// MARK: - UIScrollView Utils

public extension UIScrollView {

    func edgeScrollViewToSuperView() {
        self.edgesToSuperview()
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .always
        }
        self.autoLayout.width(to: self.superview!) // NEEDS THIS!
    }

    // Solving the issue : uiscrollview scrollable content size ambiguity
    // https://stackoverflow.com/questions/19036228/uiscrollview-scrollable-content-size-ambiguity
    func addContentView() -> UIView {
        let contentView: UIView = UIView()
        self.addSubview(contentView)
        contentView.autoLayout.edgesToSuperview()
        guard let superview = self.superview else {
            DevTools.assert(false, message: "Superview is nil")

            return contentView
        }
        contentView.autoLayout.size(to: superview)
        return contentView
    }

    func addStackView(_ stackView: UIStackView) {
        let contentView = self.uiUtils.addContentView()
        contentView.addSubview(stackView)
        stackView.uiUtils.edgeStackViewToSuperView()
    }
}

public extension GoodToGoProgramaticUIUtils where GoodToGoBase: UIScrollView {
    func edgeScrollViewToSuperView() { self.base.edgeScrollViewToSuperView() }
    func addContentView() -> UIView { self.base.addContentView() }
    func addStackView(_ stackView: UIStackView) { self.base.addStackView(stackView) }
}

// MARK: - StackView Utils

public extension UIStackView {

    func edgeStackViewToSuperView() {
        guard self.superview != nil else {
            DevTools.Log.error("\(Self.self) - edgeStackViewToSuperView : No super view for [\(self)]")
            return
        }
        self.autoLayout.edgesToSuperview() // Don't use RJPSLayouts. It will fail if scroll view is inside of stack view with lots of elements
        self.autoLayout.width(to: superview!) // NEEDS THIS!
    }

    func addSection(title: String, font: AppFonts.Styles = .paragraphMedium, color: ColorName = .primary, barSize: CGFloat = 1) {
        addSeparator()
        addSeparator(withSize: barSize, color: color.rawValue)
        let label = UILabel()
        label.text = title
        label.font = font.rawValue
        label.textAlignment = .center
        label.textColor = color.rawValue
        addSub(view: label)
        addSeparator()
    }

    // If value=0, will use as separator size will (look) be twice the current
    // stack view separator (trust me)
    @discardableResult
    func addSeparator(withSize value: CGFloat=0, color: UIColor = .clear, tag: Int? = nil) -> UIView {
        let separator = UIView()
        separator.backgroundColor = color
        if tag != nil {
            separator.tag = tag!
        }
        self.addArrangedSubview(separator)
        var finalValue = value
        if finalValue == 0 && self.spacing == 0 {
            // No space passed, and the stack view does not have space? Lets force a space
            finalValue = 10
        }
        if self.axis == .horizontal {
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

    // Given some vertical stack view, will add a new view centred on the horizontal axe
    func addSub(centeredView: UIView) {
        let baseViewHasVerticalAxis = self.axis == .vertical
        let horizontalSV = UIStackView()
        horizontalSV.axis = baseViewHasVerticalAxis ? .horizontal : .vertical
        horizontalSV.distribution = .equalCentering
        horizontalSV.alignment = .center
        let viewL = UIView()
        let viewR = UIView()
        let views = [viewL, centeredView, viewR]
        views.forEach { (some) in
            horizontalSV.addSub(view: some)
        }
        self.addSub(view: horizontalSV)
        let excludedEdges: TinyConstraints.LayoutEdge = baseViewHasVerticalAxis ? .init([.top, .bottom]) : .init([.leading, .trailing])
        horizontalSV.autoLayout.edgesToSuperview(excluding: excludedEdges)
    }

    func addSub(view: UIView) {
        self.add(view)
    }

    private func add(_ view: UIView) {
        if view.superview == nil {
            self.addArrangedSubview(view)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
}

public extension GoodToGoProgramaticUIUtils where GoodToGoBase: UIStackView {
    func addSub(view: UIView) { self.base.addSub(view: view) }
    func addSub(centeredView: UIView) { self.base.addSub(centeredView: centeredView) }
    func edgeStackViewToSuperView() { self.base.edgeStackViewToSuperView() }
    func safeRemove(_ view: UIView) { self.base.safeRemove(view) }
    @discardableResult
    func addSeparator(withSize value: CGFloat=0, color: UIColor = .clear, tag: Int? = nil) -> UIView {
        return self.base.addSeparator(withSize: value, color: color, tag: tag)
    }
    func addSection(title: String, font: AppFonts.Styles = .paragraphMedium, color: ColorName = .primary, barSize: CGFloat = 1) {
        return base.addSection(title: title, font: font, color: color, barSize: barSize)
    }
}

public extension GoodToGoProgramaticUIUtils where GoodToGoBase: UIImageView {

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

public extension GoodToGoProgramaticUIUtils where GoodToGoBase: UIView {

    func addAndSetup(scrollView: UIScrollView, stackViewV: UIStackView, hasTopBar: Bool) {
        self.base.addSubview(scrollView)
        scrollView.addSubview(stackViewV)
        stackViewV.uiUtils.edgeStackViewToSuperView()
        let topBarSize: CGFloat = hasTopBar ? TopBar.defaultHeight(usingSafeArea: false) : 0
        let bottomBarSize: CGFloat = 0//BottomBar.backgroundHeight
        scrollView.autoLayout.trailingToSuperview()
        scrollView.autoLayout.leftToSuperview()
        scrollView.autoLayout.topToSuperview(offset: topBarSize, usingSafeArea: false)
        scrollView.autoLayout.height(screenHeight - topBarSize  - bottomBarSize)
    }
    
    func marginToSuperVerticalStackView(trailing: CGFloat, leading: CGFloat) {
        self.base.autoLayout.marginToSuperVerticalStackView(trailing: trailing, leading: leading)
    }

    func marginToSuperHorizontalStackView(top: CGFloat, bottom: CGFloat) {
        self.base.autoLayout.marginToSuperHorizontalStackView(top: top, bottom: bottom)
    }

    func setVisibilityTo(_ value: Bool) {
        self.base.isUserInteractionEnabled = value ? true : false
        self.base.alpha = value ? 1 : 0
        self.base.subviews.forEach { (some) in
            some.alpha = value ? 1 : 0
        }
    }

    func addShadow() {
        self.base.addShadow()
    }

    func setWidthAnchor(value: CGFloat) {
        self.base.translatesAutoresizingMaskIntoConstraints = false
        self.base.widthAnchor.constraint(equalToConstant: value).isActive = true
    }

    func setHeightAnchor(value: CGFloat) {
        self.base.translatesAutoresizingMaskIntoConstraints = false
        self.base.heightAnchor.constraint(equalToConstant: value).isActive = true
    }

}
