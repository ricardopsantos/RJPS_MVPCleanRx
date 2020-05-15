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

open class TopBar: BaseViewControllerMVP {

    deinit {
        //AppLogger.log("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }

    private var _btnSize: CGFloat { return TopBar.defaultHeight / 2.0 }

    private lazy var _btnBack: UIButton = {
        let some = UIKitFactory.button(baseView: self.view, style: .dismiss)
        some.rjsALayouts.setMargin(_btnSize/2, on: .left)
        some.rjsALayouts.setMargin(_btnSize/2, on: .top)
        some.rjsALayouts.setSize(CGSize(width: _btnSize, height: _btnSize))
        some.setTitleForAllStates("<")
        some.isHidden = true
        some.isUserInteractionEnabled = false
        return some
    }()

    private lazy var _btnClose: UIButton = {
        let some = UIKitFactory.raisedButton(title: "X")
        self.view.addSubview(some)
        some.rjsALayouts.setMargin(_btnSize/2, on: .right)
        some.rjsALayouts.setMargin(_btnSize/2, on: .top)
        some.rjsALayouts.setSize(CGSize(width: _btnSize, height: _btnSize))
        some.setTitleForAllStates("X")
        some.addCorner(radius: 5)
        some.backgroundColor = UIColor.App.onPrimary.withAlphaComponent(FadeType.regular.rawValue)
        some.titleLabel?.textColor = UIColor.App.primary
        some.setTitleColor(UIColor.App.primary, for: .normal)
        some.isHidden = true
        some.isUserInteractionEnabled = false
        return some
    }()

    private lazy var _lblTitle: UILabelWithPadding = {
        let some = UIKitFactory.labelWithPadding(style: .navigationBarTitle)
        self.view.addSubview(some)
        some.textAlignment = .center
        some.rjsALayouts.setMargin(_btnSize*2, on: .left)
        some.rjsALayouts.setMargin(_btnSize*2, on: .right)
        some.rjsALayouts.setMargin(0, on: .top)
        some.rjsALayouts.setMargin(0, on: .bottom)
        some.numberOfLines = 0
        return some
    }()

    private func enable(btn: UIButton) {
        btn.isHidden                 = false
        btn.isUserInteractionEnabled = true
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        self.view.backgroundColor    = TopBar.defaultColor
    }
}

/**
 * Public stuff
 */
extension TopBar {
    public static var defaultColor: UIColor { UIColor.App.TopBar.background }

    public static var defaultHeight: CGFloat { return 60 }
    public func addBackButton() { enable(btn: _btnBack) }
    public func addDismissButton() { enable(btn: _btnClose) }
    public func setTitle(_ title: String) { _lblTitle.textAnimated = title }
    public func lazyLoad() {
        _btnBack.lazyLoad()
        _btnClose.lazyLoad()
        _lblTitle.lazyLoad()
        /* Lazy var auxiliar */
    }
    
    public var rxSignal_btnDismissTapped: Signal<Void> {
        return _btnClose.rx.controlEvent(.touchUpInside).asSignal()
    }
    
    public var rxSignal_btnBackTapped: Signal<Void> {
        return _btnBack.rx.controlEvent(.touchUpInside).asSignal()
    }
    
    public var rxSignal_viewTapped: Signal<CGPoint> {
        return _lblTitle.rx
            .tapGesture()
            .when(.recognized)
            .map({ $0.location(in: $0.view)})
            .asSignal(onErrorJustReturn: .zero)
    }
}

public extension TopBar {
    func injectOn(viewController: UIViewController) {
        let screenWidth = UIScreen.main.bounds.width
        let height      = TopBar.defaultHeight
        let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
        viewController.view.addSubview(container)
        UIViewController.rjs.loadViewControllerInContainedView(sender: viewController,
                                                               senderContainedView: container,
                                                               controller: self) { (_, _) in }

        container.rjsALayouts.setMargin(0, on: .top)
        container.rjsALayouts.setMargin(0, on: .right)
        container.rjsALayouts.setMargin(0, on: .left)
        container.rjsALayouts.setHeight(TopBar.defaultHeight)

        self.view.rjsALayouts.setMargin(0, on: .top)
        self.view.rjsALayouts.setMargin(0, on: .right)
        self.view.rjsALayouts.setMargin(0, on: .left)
        self.view.rjsALayouts.setHeight(TopBar.defaultHeight)

        self.lazyLoad()

    }
}
