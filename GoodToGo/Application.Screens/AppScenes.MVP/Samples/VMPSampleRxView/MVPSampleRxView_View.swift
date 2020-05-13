//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
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
    class MVPSampleRxView_View: BaseViewControllerMVP {
        
        deinit {
            //AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: MVPSampleRxView_PresenterProtocol!
        
        private let _margin: CGFloat = Designables.Sizes.Margins.defaultMargin

        private lazy var _txtUser: UITextField = {
            let some = UIKitFactory.textField(baseView: self.view)
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
            let some = UIKitFactory.textField(baseView: self.view)
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
        
        private lazy var _lblMessage: UILabel = {
            let some = UIKitFactory.label(baseView: self.view, style: .value)
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
        
        private lazy var _btnLogin: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Login", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin*2, on: .top, from: _txtPass)
            some.rjsALayouts.setHeight(_margin*2)
            some.rx.tap
                .subscribe({ [weak self] _ in
                    some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                        guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                        self.presenter.userDidTryToLoginWith(user: self._txtUser.text!, password: self._txtPass.text!)
                    })
                })
                .disposed(by: disposeBag)
            
            let isPasswordValid = _txtPass.rx.text.orEmpty.map { $0.count >= 8 }.distinctUntilChanged()
            let isEmailValid    = _txtUser.rx.text.orEmpty.map({ $0.count >= 5 && $0.contains("@") }).distinctUntilChanged()
            let isButtonEnabled = Observable.combineLatest(isPasswordValid, isEmailValid) { $0 && $1 }
            isButtonEnabled.bind(to: some.rx.isEnabled).disposed(by: disposeBag)
            isButtonEnabled.subscribe(onNext: { some.alpha = $0 ? 1 : 0.5 }).disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btnPush: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Push", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth((screenWidth / 2) - (1.5 * _margin))
            some.rjsALayouts.setMargin(_margin*2, on: .top, from: _lblMessage)
            some.rjsALayouts.setHeight(_margin*2)
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    let someString = "[\(self._txtUser.text ?? "")][\(self._txtPass.text ?? "")]"
                    let vm = VM.MVPSampleRxView_ViewModel(someString: someString )
                    self.presenter.router.presentControllerWith(vm: vm)
                })
            })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btnDismiss: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Dismiss", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((screenWidth / 2) - (1.5 * _margin))
            some.rjsALayouts.setMargin(_margin*2, on: .top, from: _lblMessage)
            some.rjsALayouts.setHeight(_margin*2)
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.presenter.router.dismissView()
                })
            })
                .disposed(by: disposeBag)
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
            _txtUser.lazyLoad()
            _txtPass.lazyLoad()
            _btnLogin.lazyLoad()
            _lblMessage.lazyLoad()
            _btnPush.lazyLoad()
            _btnDismiss.lazyLoad()
            _txtUser.text = "admin@admin.com"
            _txtPass.text = "admin"
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension V.MVPSampleRxView_View: MVPSampleRxView_ViewProtocol {
    func updateViewWith(message: String) {
        _lblMessage.textAnimated = message
    }
}
