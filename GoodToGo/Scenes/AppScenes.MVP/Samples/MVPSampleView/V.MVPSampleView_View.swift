//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
import Swinject
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Designables

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

extension V {
    class MVPSampleView_View: BaseViewControllerMVP {
        
        deinit {
            if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self.className) was killed") }
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: MVPSampleView_PresenterProtocol!
        
        private let margin: CGFloat = Designables.Sizes.Margins.defaultMargin

        private lazy var txtUser: UITextField = {
            let some = UIKitFactory.textField(baseView: self.view)
            some.font      = AppFonts.regular
            some.textColor = AppColors.lblTextColor
            some.backgroundColor      = AppColors.lblBackgroundColor
            some.layer.masksToBounds  = false
            some.layer.cornerRadius   = 8
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin, on: .top)
            some.rjsALayouts.setHeight(margin)
            return some
        }()
        
        private lazy var txtPass: UITextField = {
            let some = UIKitFactory.textField(baseView: self.view)
            some.font = AppFonts.regular
            some.backgroundColor      = AppColors.lblBackgroundColor
            some.isSecureTextEntry    = true
            some.layer.masksToBounds  = false
            some.layer.cornerRadius   = 8
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin, on: .top, from: txtUser)
            some.rjsALayouts.setHeight(margin)
            return some
        }()
        
        private lazy var btnLogin: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: Messages.login.localised, style: .regular)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin*2, on: .top, from: txtPass)
            some.rjsALayouts.setHeight(margin*2)
            some.onTouchUpInside { [weak self] in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    let user = self.txtUser.text
                    let pass = self.txtPass.text
                    self.presenter.userDidTryToLoginWith(user: user!, password: pass!)
                })
            }
            return some
        }()
        
        private lazy var lblMessage: UILabel = {
            let some = UIKitFactory.label(baseView: self.view, style: .value)
            some.font = AppFonts.regular
            some.backgroundColor      = AppColors.lblBackgroundColor
            some.layer.masksToBounds  = false
            some.layer.cornerRadius   = 8
            some.textAlignment        = .center
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin, on: .top, from: btnLogin)
            some.rjsALayouts.setHeight(margin*2)
            return some
        }()
        
        private lazy var btnPush: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Push", style: .regular)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setWidth((screenWidth / 2) - (1.5 * margin))
            some.rjsALayouts.setMargin(margin*2, on: .top, from: lblMessage)
            some.rjsALayouts.setHeight(margin*2)
            some.onTouchUpInside { [weak self] in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.presenter.router.presentControllerWith(vm: nil)
                })
            }
            return some
        }()
        
        private lazy var btnDismiss: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Dismiss", style: .regular)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setWidth((screenWidth / 2) - (1.5 * margin))
            some.rjsALayouts.setMargin(margin*2, on: .top, from: lblMessage)
            some.rjsALayouts.setHeight(margin*2)
            some.onTouchUpInside { [weak self] in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.presenter.router.dismissView()
                })
            }
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
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
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            txtUser.lazyLoad()
            txtPass.lazyLoad()
            btnLogin.lazyLoad()
            lblMessage.lazyLoad()
            btnPush.lazyLoad()
            btnDismiss.lazyLoad()
            txtUser.text = "admin@admin.com"
            txtPass.text = "admin"
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension V.MVPSampleView_View: MVPSampleView_ViewProtocol {
    func updateViewWith(message: String) {
        lblMessage.textAnimated = message
    }
}
