//
//  LabelWithPadding.swift
//  Designables
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import TinyConstraints

import AppConstants
import AppTheme
import DevTools
import PointFreeFunctions
import UIBase

//
// Its just a view with a UILabel inside.
// For fast label access just use [public lazy var label: UILabel] property
//

open class UILabelWithPadding: UIView {

    var _padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    public var padding: UIEdgeInsets { _padding }
    private var paddingWasApplied = false
    
    public lazy var label: UILabel = {
        let some = UIKitFactory.label(style: .value)
        addSubview(some)
        return some
    }()
    
    private func unifyColors() {
        // Keep the same colour than the label
        self.backgroundColor = label.backgroundColor
        label.backgroundColor = .clear
    }
    
    var layoutStyle: UILabel.LayoutStyle {
        set {
            label.layoutStyle = newValue
            unifyColors()
        }
        get { return .notApplied }
    }
    
    public func apply(style: UILabel.LayoutStyle) {
        layoutStyle = style
        unifyColors()
    }
    
    public var numberOfLines: Int = 0 {
        didSet { label.numberOfLines = numberOfLines }
    }
    
    public var textColor: UIColor = .black {
        didSet { label.textColor = textColor }
    }
    
    public var textAlignment: NSTextAlignment = .left {
        didSet { label.textAlignment = textAlignment }
    }
    
    public var text: String = "" {
        didSet { label.text = text }
    }
    
    public var textAnimated: String = "" {
        didSet { label.textAnimated = textAnimated }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func applyPadding() {
        guard !paddingWasApplied else { return }
        label.rjsALayouts.setMargin(padding.top, on: .top)
        label.rjsALayouts.setMargin(padding.left, on: .left)
        label.rjsALayouts.setMargin(padding.right, on: .right)
        label.rjsALayouts.setMargin(padding.bottom, on: .bottom)
        paddingWasApplied = true
    }
    public convenience init(padding: UIEdgeInsets?, text: String="") {
        self.init(frame: .zero)
        self.text = text
        if padding != nil {
            self._padding = padding!
        }
        //if self._padding .top + self._padding .left + self._padding .right + self._padding .bottom == 0 {
        //    DevTools.Log.warning("No padding")
        //}
        applyPadding()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupView() {
        applyPadding()
    }
}
