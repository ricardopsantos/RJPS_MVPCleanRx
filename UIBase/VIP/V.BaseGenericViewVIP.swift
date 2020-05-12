//
//  BaseGenericView.swift
//  i9
//
//  Created by Ricardo Santos on 31/01/2020.
//  Copyright © 2020 Crédito Agrícola. All rights reserved.
//
import Foundation
import UIKit
//
import RxCocoa
import RxSwift
//
import DevTools
import PointFreeFunctions

// MARK: - BaseGenericView
open class BaseGenericViewVIP: StylableView {
    public var disposeBag = DisposeBag()

    public init() {
        super.init(frame: .zero)
        doViewLifeCycle()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        doViewLifeCycle()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        doViewLifeCycle()
    }

    private func doViewLifeCycle() {
        prepareLayoutCreateHierarchy()           // DONT CHANGE ORDER
        prepareLayoutBySettingAutoLayoutsRules() // DONT CHANGE ORDER
        prepareLayoutByFinishingPrepareLayout()  // DONT CHANGE ORDER
        setupViewUIRx()                          // DONT CHANGE ORDER
        setupColorsAndStyles()
    }

    // What should this function be used for? Add stuff to the view zone....
    // ...
    // addSubview(scrollView)
    // scrollView.addSubview(stackViewVLevel1)
    // ...
    //
    open func prepareLayoutCreateHierarchy() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Setup layout rules zone....
    // ...
    // someView.autoLayout.widthToSuperview()
    // someView.autoLayout.bottomToSuperview()
    // ...
    //
    open func prepareLayoutBySettingAutoLayoutsRules() {
        assert(false, message: "Override me")
    }

    // What should this function be used for? Extra stuff zone (not included in [prepareLayoutCreateHierarchy]
    // and [prepareLayoutBySettingAutoLayoutsRules]
    // ...
    // table.separatorColor = .clear
    // table.rx.setDelegate(self).disposed(by: disposeBag)
    // label.textAlignment = .center
    // ...
    open func prepareLayoutByFinishingPrepareLayout() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    open func setupColorsAndStyles() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    open func setupViewUIRx() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }
}
