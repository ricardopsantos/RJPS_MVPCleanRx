//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension AppView {
    class TopBar: GenericView {

        deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        private var _btnSize: CGFloat { return TopBar.defaultHeight / 2.0 }
        
        private lazy var _btnBack: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, style: .dismiss)
            some.rjsALayouts.setMargin(_btnSize/2, on: .left)
            some.rjsALayouts.setMargin(_btnSize/2, on: .top)
            some.rjsALayouts.setSize(CGSize(width: _btnSize, height: _btnSize))
            some.setTitleForAllStates("<")
            some.isHidden = true
            some.isUserInteractionEnabled = false
            return some
        }()
        
        private lazy var _btnClose: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, style: .dismiss)
            some.rjsALayouts.setMargin(_btnSize/2, on: .right)
            some.rjsALayouts.setMargin(_btnSize/2, on: .top)
            some.rjsALayouts.setSize(CGSize(width: _btnSize, height: _btnSize))
            some.setTitleForAllStates("X")
            some.isHidden = true
            some.isUserInteractionEnabled = false
            return some
        }()
        
        private lazy var _lblTitle: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self.view, style: .title)
            some.textAlignment = .center
            some.rjsALayouts.setMargin(_btnSize*2, on: .left)
            some.rjsALayouts.setMargin(_btnSize*2, on: .right)
            some.rjsALayouts.setMargin(0, on: .top)
            some.rjsALayouts.setMargin(0, on: .bottom)
            some.numberOfLines = 0
            some.layoutStyle   = .title
            some.textColor     = AppColors.TopBar.titleColor
            return some
        }()
        
        private func enable(btn: UIButton) {
            btn.isHidden                 = false
            btn.isUserInteractionEnabled = true
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            self.view.backgroundColor    =  AppColors.TopBar.background
        }
    }
}

/**
 * Public stuff
 */
extension V.TopBar {

    static var defaultHeight: CGFloat { return 60 }
    func addBackButton() { enable(btn: _btnBack) }
    func addDismissButton() { enable(btn: _btnClose) }
    func setTitle(_ title: String) { _lblTitle.text = title }
    func lazyLoad() { /* Lazy var auxiliar */ }
    
    var rxSignal_btnDismissTapped: Signal<Void> {
        return _btnClose.rx.controlEvent(.touchUpInside).asSignal()
    }
    
    var rxSignal_btnBackTapped: Signal<Void> {
        return _btnBack.rx.controlEvent(.touchUpInside).asSignal()
    }
    
    var rxSignal_viewTapped: Signal<CGPoint> {
        return _lblTitle.rx
            .tapGesture()
            .when(.recognized)
            .map({ $0.location(in: $0.view)})
            .asSignal(onErrorJustReturn: .zero)
    }
    
}
