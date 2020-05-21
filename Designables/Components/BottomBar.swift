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

open class BottomBar: BaseViewControllerMVP {
    
    deinit {
        DevTools.Log.logDeInit("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    weak var delegate: BottomBar_Delegate?
    
    private lazy var btn1: UIButton = {
        let some = UIKitFactory.button(baseView: self.view, style: .alternative)
        some.setTitleForAllStates("1")
        some.rx.tap.subscribe({ [weak self] _ in
            some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                self?.delegate?.btnTappedWith(identifier: "1")
            })
        }).disposed(by: disposeBag)
        return some
    }()
    
    private lazy var btn2: UIButton = {
        let some = UIKitFactory.button(baseView: self.view, style: .alternative)
        some.setTitleForAllStates("2")
        some.rx.tap.subscribe({ [weak self] _ in
            some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                self?.delegate?.btnTappedWith(identifier: "2")
            })
        }).disposed(by: disposeBag)
        return some
    }()
    
    private lazy var btn3: UIButton = {
        let some = UIKitFactory.button(baseView: self.view, style: .alternative)
        some.setTitleForAllStates("3")
        some.rx.tap.subscribe({ [weak self] _ in
            some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                self?.delegate?.btnTappedWith(identifier: "3")
            })
        }).disposed(by: disposeBag)
        return some
    }()
    
    private lazy var btn4: UIButton = {
        let some = UIKitFactory.button(baseView: self.view, style: .alternative)
        some.setTitleForAllStates("4")
        some.rx.tap.subscribe({ [weak self] _ in
            some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                self?.delegate?.btnTappedWith(identifier: "4")
            })
        }).disposed(by: disposeBag)
        return some
    }()
    
    private lazy var btn5: UIButton = {
        let some = UIKitFactory.button(baseView: self.view, style: .alternative)
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
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        self.view.backgroundColor = UIColor.App.primary
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppearance {
            self.lazyLoad()
        }
    }
    public override func prepareLayoutCreateHierarchy() {
        let viewBack = UIView()
        viewBack.backgroundColor = .cyan
        self.view.addSubview(viewBack)
        let viewBackMarginTop = BottomBar.defaultHeight - BottomBar.backgroundHeight
        viewBack.rjsALayouts.setMargin(0, on: .left)
        viewBack.rjsALayouts.setMargin(0, on: .right)
        viewBack.rjsALayouts.setMargin(0, on: .bottom)
        viewBack.rjsALayouts.setMargin(viewBackMarginTop, on: .top)
        
        self.view.backgroundColor = .clear
        
    }
    
    public override func prepareLayoutBySettingAutoLayoutsRules() {
        
        let btns =  [btn1, btn2, btn3, btn4, btn5]
        let k: CGFloat = 0.3
        let dimH = BottomBar.backgroundHeight*(1.0-k)
        let dimW = (screenWidth / (CGFloat(btns.count+1)))
        
        let margin: CGFloat = BottomBar.defaultHeight*(k/2.0)
        let btnSize = CGSize(width: dimW, height: dimH)
        btns.forEach { (some) in
            if some == btn3 {
                btn3.backgroundColor = UIColor.App.primary
                some.rjsALayouts.setWidth(dimW)
                some.rjsALayouts.setMargin(margin, on: .top)
            } else {
                some.rjsALayouts.setSize(btnSize)
            }
            some.rjsALayouts.setMargin(margin, on: .bottom)
        }
        
        btn1.rjsALayouts.setMargin(margin, on: .left)
        btn2.rjsALayouts.setMargin(margin, on: .left, from: btn1)
        btn3.rjsALayouts.setMargin(margin, on: .left, from: btn2)
        btn4.rjsALayouts.setMargin(margin, on: .left, from: btn3)
        btn5.rjsALayouts.setMargin(margin, on: .left, from: btn4)
    }
    
    public override func prepareLayoutByFinishingPrepareLayout() {
        
    }
    
}

/**
 * Public stuff
 */
public extension BottomBar {
    static var defaultHeight: CGFloat { return 100 }
    static var backgroundHeight: CGFloat { return defaultHeight-30 }
    func lazyLoad() { /* Lazy var auxiliar */ }
}

public extension BottomBar {

    // [usingSafeArea=false] will make the BottomBar go down and use space on the safe area
    func injectOn(viewController: UIViewController, usingSafeArea: Bool = false) {
        self.view.backgroundColor = .clear
        let container   = UIView()
        container.backgroundColor = .clear
        viewController.view.addSubview(container)
        UIViewController.loadViewControllerInContainedView(sender: viewController,
                                                               senderContainedView: container,
                                                               controller: self) { (_, _) in }

        container.rjsALayouts.setMargin(0, on: .bottom)
        container.rjsALayouts.setMargin(0, on: .right)
        container.rjsALayouts.setMargin(0, on: .left)
        container.rjsALayouts.setHeight(BottomBar.defaultHeight)

        self.view.rjsALayouts.setMargin(0, on: .top)
        self.view.rjsALayouts.setMargin(0, on: .right)
        self.view.rjsALayouts.setMargin(0, on: .left)
        self.view.rjsALayouts.setHeight(BottomBar.defaultHeight)

    }
}
