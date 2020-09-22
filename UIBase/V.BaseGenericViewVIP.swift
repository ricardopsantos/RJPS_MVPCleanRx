//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Crédito Agrícola. All rights reserved.
//
import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import DevTools
//
import PointFreeFunctions
import AppTheme
import AppConstants
import Core
import Domain

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

    open func prepareLayoutCreateHierarchy() {
        // What should this function be used for? Add stuff to the view zone....
        // ...
        // addSubview(scrollView)
        // scrollView.addSubview(stackViewVLevel1)
        // ...
        //
        DevTools.Log.warning("\(self.className) : \(DevTools.Strings.overrideMe.rawValue)")
    }

    open func prepareLayoutBySettingAutoLayoutsRules() {
        // What should this function be used for? Setup layout rules zone....
        // ...
        // someView.autoLayout.widthToSuperview()
        // someView.autoLayout.bottomToSuperview()
        // ...
        //
        DevTools.Log.warning("\(self.className) : \(DevTools.Strings.overrideMe.rawValue)")
    }

    open func prepareLayoutByFinishingPrepareLayout() {
        // What should this function be used for? Extra stuff zone (not included in [prepareLayoutCreateHierarchy]
        // and [prepareLayoutBySettingAutoLayoutsRules]
        // ...
        // table.separatorColor = .clear
        // table.rx.setDelegate(self).disposed(by: disposeBag)
        // label.textAlignment = .center
        // ...
        DevTools.Log.warning("\(self.className) : \(DevTools.Strings.overrideMe.rawValue)")
    }

    open func setupColorsAndStyles() {
        DevTools.Log.warning("\(self.className) : \(DevTools.Strings.overrideMe.rawValue)")
    }

    open func setupViewUIRx() {
        DevTools.Log.warning("\(self.className) : \(DevTools.Strings.overrideMe.rawValue)")
    }
}

//
// MARK: - BaseViewControllerMVPProtocol
//

extension BaseGenericViewVIP: BaseViewProtocol {
    public func displayMessage(_ message: String, type: AlertType) {
        if let messagesManager = RootAssemblyResolver.messagesManager {
            messagesManager.displayMessage(message, type: type)
        }
    }
}
