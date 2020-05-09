//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RxGesture
//
import UIBase
import AppConstants
import DevTools
import PointFreeFunctions

public protocol BottomBar_Delegate: AnyObject {
    func btnTappedWith(identifier: String)
}

public extension AppView {
    class BottomBar: GenericView {

        deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        weak var delegate: BottomBar_Delegate?
        
        private lazy var _btn1: UIButton = {
            let some = Factory.UIKit.button(baseView: self.view, style: .alternative)
            some.setTitleForAllStates("1")
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    self?.delegate?.btnTappedWith(identifier: "1")
                })
            }).disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btn2: UIButton = {
            let some = Factory.UIKit.button(baseView: self.view, style: .alternative)
            some.setTitleForAllStates("2")
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    self?.delegate?.btnTappedWith(identifier: "2")
                })
            }).disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btn3: UIButton = {
            let some = Factory.UIKit.button(baseView: self.view, style: .alternative)
            some.setTitleForAllStates("3")
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    self?.delegate?.btnTappedWith(identifier: "3")
                })
            }).disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btn4: UIButton = {
            let some = Factory.UIKit.button(baseView: self.view, style: .alternative)
            some.setTitleForAllStates("4")
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    self?.delegate?.btnTappedWith(identifier: "4")
                })
            }).disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btn5: UIButton = {
            let some = Factory.UIKit.button(baseView: self.view, style: .alternative)
            some.setTitleForAllStates("5")
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    self?.delegate?.btnTappedWith(identifier: "5")
                })
            }).disposed(by: disposeBag)
            return some
        }()
        
        public override func loadView() {
            super.loadView()
            prepareLayout()
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            self.view.backgroundColor = UIColor.App.TopBar.background
        }
        
        public override func prepareLayout() {
             super.prepareLayout()

            let viewBack = UIView()
            viewBack.backgroundColor = .cyan
            self.view.addSubview(viewBack)
            let viewBackMarginTop = V.BottomBar.defaultHeight() - V.BottomBar.backgroundHeight()
            viewBack.rjsALayouts.setMargin(0, on: .left)
            viewBack.rjsALayouts.setMargin(0, on: .right)
            viewBack.rjsALayouts.setMargin(0, on: .bottom)
            viewBack.rjsALayouts.setMargin(viewBackMarginTop, on: .top)

            self.view.backgroundColor = .clear
            let btns =  [_btn1, _btn2, _btn3, _btn4, _btn5]
            let k: CGFloat = 0.3
            let dimH = V.BottomBar.backgroundHeight()*(1.0-k)
            let dimW = (screenWidth / (CGFloat(btns.count+1)))
            
            let margin: CGFloat = V.BottomBar.defaultHeight()*(k/2.0)
            let btnSize = CGSize(width: dimW, height: dimH)
            btns.forEach { (some) in
                if some == _btn3 {
                    _btn3.backgroundColor = .red
                    some.rjsALayouts.setWidth(dimW)
                    some.rjsALayouts.setMargin(margin, on: .top)
                } else {
                    some.rjsALayouts.setSize(btnSize)
                }
                some.rjsALayouts.setMargin(margin, on: .bottom)
            }
            
            _btn1.rjsALayouts.setMargin(margin, on: .left)
            _btn2.rjsALayouts.setMargin(margin, on: .left, from: _btn1)
            _btn3.rjsALayouts.setMargin(margin, on: .left, from: _btn2)
            _btn4.rjsALayouts.setMargin(margin, on: .left, from: _btn3)
            _btn5.rjsALayouts.setMargin(margin, on: .left, from: _btn4)
        }
    }
}

/**
 * Public stuff
 */
extension V.BottomBar {
    static func defaultHeight() -> CGFloat { return 100 }
    static func backgroundHeight() -> CGFloat { return defaultHeight()-30 }
    func lazyLoad() { /* Lazy var auxiliar */ }
}
