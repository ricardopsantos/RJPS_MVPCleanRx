//
//  V.CarTrackLoginView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
import SkyFloatingLabelTextField
import Material
import Motion
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

extension V {
    class CarTrackLoginView: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        //var rxUserName = BehaviorSubject<String?>(value: nil)
        //var rxPassword = BehaviorSubject<String?>(value: nil)

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var scrollView: UIScrollView = {
            UIKitFactory.scrollView()
        }()

        private lazy var stackViewVLevel1: UIStackView = {
            UIKitFactory.stackView(axis: .vertical)
        }()

        private lazy var lblTitle: UILabel = {
            UIKitFactory.label(style: .title)
        }()

        private lazy var lblErrorMessage: UILabel = {
            return UIKitFactory.label(style: .error)
        }()

        private lazy var btnLogin: UIButton = {
            let button = UIKitFactory.raisedButton(title: Messages.login.localised)
            return button
        }()

        private lazy var txtPassword: SkyFloatingLabelTextField = {
            let some = UIKitFactory.skyFloatingLabelTextField(title: Messages.password.localised,
                                                              placeholder: "Your \(Messages.password.localised)")
            some.isSecureTextEntry = true
            some.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            return some
        }()

        private lazy var txtUserName: SkyFloatingLabelTextField = {
            let some = UIKitFactory.skyFloatingLabelTextField(title: Messages.email.localised,
                                                              placeholder: "Your \(Messages.invalidEmail.localised)")
            some.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            return some
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {

            addSubview(scrollView)
            scrollView.addSubview(stackViewVLevel1)
            stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: screenHeight/5)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(txtUserName)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(txtPassword)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblErrorMessage)
            addSubview(btnLogin)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            let margin = AppSizes.Margins.defaultMargin
            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(screenHeight)

            self.subViewsOf(types: [.button, .label], recursive: true).forEach { (some) in
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                some.autoLayout.marginToSuperVerticalStackView(trailing: margin,
                                                               leading: margin)
            }

            btnLogin.autoLayout.centerXToSuperview()
            btnLogin.autoLayout.centerYToSuperview()
            btnLogin.autoLayout.leadingToSuperview(offset: margin)
            btnLogin.autoLayout.trailingToSuperview(offset: margin)
            btnLogin.autoLayout.height(Designables.Sizes.Button.defaultSize.height)

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            self.subViewsOf(types: [.label], recursive: true).forEach { (some) in
                (some as? UILabel)?.textAlignment = .center
            }
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.appDefaultBackgroundColor
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // This will notify us when something has changed on the textfield
        @objc func textFieldDidChange(_ textfield: UITextField) {

        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        func setupWith(screenState viewModel: VM.CarTrackLogin.ScreenState.ViewModel) {
            screenLayout = viewModel.layout
        }

        func setupWith(screenInitialState viewModel: VM.CarTrackLogin.ScreenInitialState.ViewModel) {
            lblTitle.textAnimated = viewModel.title
            txtUserName.text = viewModel.userName
            txtPassword.text = viewModel.password
            screenLayout = viewModel.screenLayout
        }

        private func userCanProceed(_ value: Bool) {
            if value {
                btnLogin.enable()
            } else {
                btnLogin.disable()
            }
        }
        func setupWith(nextButtonState viewModel: VM.CarTrackLogin.NextButtonState.ViewModel) {
            userCanProceed(viewModel.isEnabled)
        }

        var screenLayout: E.CarTrackLoginView.ScreenLayout = .enterUserCredentials {
            didSet {
                func setErrorMessage(_ message: String, forField: SkyFloatingLabelTextField) {
                    forField.errorMessage = message
                }
                setErrorMessage("", forField: txtUserName)
                lblErrorMessage.alpha = 0
                lblErrorMessage.text = ""
                switch screenLayout {
                case .enterUserCredentials:
                    userCanProceed(false)
                    setErrorMessage("", forField: txtPassword)
                    setErrorMessage("", forField: txtUserName)
                case .wrongUserCredencial(errorMessage: let errorMessage):
                    lblErrorMessage.textAnimated = errorMessage
                    lblErrorMessage.fadeTo(1)
                case .invalidEmailFormat(errorMessage: let errorMessage):
                    setErrorMessage(errorMessage, forField: txtUserName)
                    setErrorMessage("", forField: txtPassword)
                case .invalidPasswordFormat(errorMessage: let errorMessage):
                    setErrorMessage(errorMessage, forField: txtPassword)
                    setErrorMessage("", forField: txtUserName)
                case .invalidEmailFormatAndPasswordFormat(passwordErrorMessage: let passwordErrorMessage, emailErrorMessage: let emailErrorMessage):
                    setErrorMessage(emailErrorMessage, forField: txtUserName)
                    setErrorMessage(passwordErrorMessage, forField: txtPassword)
                case .enterPassword:
                    txtPassword.becomeFirstResponder()
                case .allFieldsAreValid:
                    setErrorMessage("", forField: txtPassword)
                    setErrorMessage("", forField: txtPassword)
                    lblErrorMessage.fadeTo(0)
                }
            }
        }
    }
}

// MARK: - Events capture

extension V.CarTrackLoginView {
    var rxBtnLoginTap: Observable<Void> { btnLogin.rx.tapSmart(disposeBag) }
    var rxTxtPassword: Reactive<SkyFloatingLabelTextField> { txtPassword.rx }
    var rxTxtUsername: Reactive<SkyFloatingLabelTextField> { txtUserName.rx }
    var txtUsernameIsFirstResponder: Bool { txtUserName.isFirstResponder }
    var txtPasswordIsFirstResponder: Bool { txtPassword.isFirstResponder }
}
