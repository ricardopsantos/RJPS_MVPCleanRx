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

    public class UILabelWithPadding: UIView {

        private var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

        public lazy var label: UILabel = {
            let some = UIKitFactory.label(style: .title)
            addSubview(some)
            return some
        }()

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

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        public convenience init(padding: UIEdgeInsets, text: String="") {
            self.init(frame: .zero)
            self.padding = padding
            self.text = text
            if padding.top + padding.left + padding.right + padding.bottom == 0 {
                AppLogger.warning("No padding")
            }
            label.rjsALayouts.setMargin(padding.top, on: .top)
            label.rjsALayouts.setMargin(padding.left, on: .left)
            label.rjsALayouts.setMargin(padding.right, on: .right)
            label.rjsALayouts.setMargin(padding.bottom, on: .bottom)
        }

        private func setupView() {
            //label.autoLayout.edgesToSuperview()
        }
    }
