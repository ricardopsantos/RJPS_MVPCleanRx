//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

extension AppView {
    class SampleView_View: GenericView {
        
        deinit {
            AppLogs.DLog("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter : SampleView_PresenterProtocol!
        
        private let _margin : CGFloat = 25
        
        private lazy var _txtUser: UITextField = {
            let some = AppFactory.UIKit.textField(baseView: self.view)
            some.font      = AppFonts.regular
            some.textColor = AppColors.lblTextColor
            some.backgroundColor      = AppColors.lblBackgroundColor
            some.layer.masksToBounds  = false
            some.layer.cornerRadius   = 8
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin, on: .top)
            some.rjsALayouts.setHeight(_margin)
            return some
        }()
        
        private lazy var _txtPass: UITextField = {
            let some = AppFactory.UIKit.textField(baseView: self.view)
            some.font = AppFonts.regular
            some.backgroundColor      = AppColors.lblBackgroundColor
            some.isSecureTextEntry    = true
            some.layer.masksToBounds  = false
            some.layer.cornerRadius   = 8
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _txtUser)
            some.rjsALayouts.setHeight(_margin)
            return some
        }()
        
        private lazy var _btnLogin: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Login", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin*2, on: .top, from: _txtPass)
            some.rjsALayouts.setHeight(_margin*2)
            some.onTouchUpInside { [weak self] in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    let user = strongSelf._txtUser.text
                    let pass = strongSelf._txtPass.text
                    strongSelf.presenter.userDidTryToLoginWith(user: user!, password: pass!)
                })
            }
            return some
        }()
        
        private lazy var _lblMessage: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self.view, style: .value)
            some.font = AppFonts.regular
            some.backgroundColor      = AppColors.lblBackgroundColor
            some.layer.masksToBounds  = false
            some.layer.cornerRadius   = 8
            some.textAlignment        = .center
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnLogin)
            some.rjsALayouts.setHeight(_margin*2)
            return some
        }()
        
        private lazy var _btnPush: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Push", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth((AppGlobal.screenWidth / 2) - (1.5 * _margin))
            some.rjsALayouts.setMargin(_margin*2, on: .top, from: _lblMessage)
            some.rjsALayouts.setHeight(_margin*2)
            some.onTouchUpInside { [weak self] in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    strongSelf.presenter.router.presentControllerWith(vm:nil)
                })
            }
            return some
        }()
        
        private lazy var _btnDismiss: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Dismiss", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((AppGlobal.screenWidth / 2) - (1.5 * _margin))
            some.rjsALayouts.setMargin(_margin*2, on: .top, from: _lblMessage)
            some.rjsALayouts.setHeight(_margin*2)
            some.onTouchUpInside { [weak self] in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    strongSelf.presenter.router.dismissView()
                })
            }
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            prepareLayout()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter.generic?.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewDidAppear()
        }
        
        override func prepareLayout() {
            super.prepareLayout()
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            _txtUser.lazyLoad()
            _txtPass.lazyLoad()
            _btnLogin.lazyLoad()
            _lblMessage.lazyLoad()
            _btnPush.lazyLoad()
            _btnDismiss.lazyLoad()
            _txtUser.text = "admin@admin.com"
            _txtPass.text = "admin"
        }
    }
}


//MARK: - View Protocol

extension V.SampleView_View : SampleView_ViewProtocol {
    func updateViewWith(message:String) {
        _lblMessage.textAnimated = message
    }
}




