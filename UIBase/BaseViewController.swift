//
//  BaseViewController.swift
//  UIBase
//
//  Created by Ricardo Santos on 20/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
//
import DevTools

/// Base for [VC.BaseGenericViewControllerVIP] and [VC.BaseGenericViewControllerMVP.swift]
open class BaseViewController: UIViewController {

    deinit {
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { DevTools.Log.log("\(self.className) was killed") }
        NotificationCenter.default.removeObserver(self)
    }

    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()
    public var firstAppearance = true

    open override func loadView() {
        super.loadView()
        doViewLifeCycle()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.executeWithDelay(delay: 0.1) { [weak self] in
            guard let self = self else { return }
            self.firstAppearance = false
        }
    }

    private func doViewLifeCycle() {
        prepareLayoutCreateHierarchy()           // DONT CHANGE ORDER
        prepareLayoutBySettingAutoLayoutsRules() // DONT CHANGE ORDER
        prepareLayoutByFinishingPrepareLayout()  // DONT CHANGE ORDER
        setupViewUIRx()                          // DONT CHANGE ORDER
    }

    // What should this function be used for? Add stuff to the view zone....
    // ...
    // addSubview(scrollView)
    // scrollView.addSubview(stackViewVLevel1)
    // ...
    //
    open func prepareLayoutCreateHierarchy() {
        DevTools.Log.warning(DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Setup layout rules zone....
    // ...
    // someView.autoLayout.widthToSuperview()
    // someView.autoLayout.bottomToSuperview()
    // ...
    //
    open func prepareLayoutBySettingAutoLayoutsRules() {
        DevTools.Log.warning(DevTools.Strings.overrideMe.rawValue)
    }

    // What should this function be used for? Extra stuff zone (not included in [prepareLayoutCreateHierarchy]
    // and [prepareLayoutBySettingAutoLayoutsRules]
    // ...
    // table.separatorColor = .clear
    // table.rx.setDelegate(self).disposed(by: disposeBag)
    // label.textAlignment = .center
    // ...
    open func prepareLayoutByFinishingPrepareLayout() {
        DevTools.Log.warning(DevTools.Strings.overrideMe.rawValue)
    }

    open func setupViewUIRx() {
        DevTools.Log.warning(DevTools.Strings.overrideMe.rawValue)
    }
}
