//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RJPSLib
import RxCocoa
import ToastSwiftFramework
//
import DevTools
import Extensions
import AppConstants
import AppResources
import PointFreeFunctions
import Domain
import AppTheme

open class BaseViewControllerMVP: UIViewController, BaseViewControllerMVPProtocol {

    deinit {
        DevTools.Log.logDeInit("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }

    public static var shared = BaseViewControllerMVP()

    public var firstAppearance = true
    var keyboardIsVisible = false

    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()

    private var stats: Stats?

    open override func loadView() {
        super.loadView()
        doViewLifeCycle()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.executeWithDelay(delay: 0.1) { [weak self] in
            guard let self = self else { return }
            self.firstAppearance = false
            self.addStatsView()
        }
    }

    open func displayMessage(_ message: String, type: AlertType) {
        var style = ToastStyle()
        style.cornerRadius = 5
        style.displayShadow = true
        style.messageFont = UIFont.App.Styles.paragraphSmall.rawValue 
        switch type {
        case .success: style.backgroundColor = UIColor.App.success.withAlphaComponent(FadeType.superLight.rawValue)
        case .warning: style.backgroundColor = UIColor.App.warning.withAlphaComponent(FadeType.superLight.rawValue)
        case .error: style.backgroundColor = UIColor.App.error.withAlphaComponent(FadeType.superLight.rawValue)
        }
        style.messageColor = .white
        DevTools.topViewController()?.view.makeToast(message, duration: 5, position: .top, style: style)
    }

    func keyboardDidShow() { }
    func keyboardDidHide() { }
    func dismissKeyboard() { }

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

//
// MARK: - loadingViewable
//

public extension BaseViewControllerMVP {
    func setActivityState(_ state: Bool) {
        if state {
            self.view.rjs.startActivityIndicator()
        } else { self.view.rjs.stopActivityIndicator() }
    }
}

//
// MARK: - Private stuff
//

extension BaseViewControllerMVP {

    private func addStatsView() {
        guard DevTools.FeatureFlag.showDebugStatsViewOnView.isTrue else { return }
        guard self.stats == nil else { return }
        self.stats = Stats()//frame: CGRect(x: 20, y: 40, width: 100.0, height: 60.0))
        self.view.addSubview(self.stats!)
        self.stats?.autoLayout.trailingToSuperview(offset: 20)
        self.stats?.autoLayout.bottomToSuperview(offset: 40)
        self.stats?.autoLayout.width(100)
        self.stats?.addShadow()
        self.stats?.addCorner(radius: 5)
//        self.stats?.superview?.bringSubviewToFront(self.stats!)
    }
}
