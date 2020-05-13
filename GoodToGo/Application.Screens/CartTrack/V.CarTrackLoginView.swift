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
import CCTextFieldEffects
import SkyFloatingLabelTextField
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

//
// INSERT INVISION/ZEPLIN RELATED LAYOUT SCREENS BELOW
//
// Colors WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/378/Colors
// Labels WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/880/Typography
// Icons WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/333/Icons
//

extension V {
    class CarTrackLoginView: BaseGenericViewVIP {

        deinit {

        }

        var rxUserName = BehaviorSubject<String?>(value: nil)
        var rxPassword = BehaviorSubject<String?>(value: nil)

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
            UIKitFactory.label(style: .value)
        }()

        private lazy var btnLogin: UIButton = {
            UIKitFactory.button(title: Messages.login.localised, style: .regular)
        }()

        private lazy var txtPassword: SkyFloatingLabelTextField = {
            let some = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 10, width: 120, height: 45))
            some.placeholder = "Password"
            some.title = "Your Password"
            some.errorColor = UIColor.red
            some.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            return some
        }()

        private lazy var txtUserName: SkyFloatingLabelTextField = {
            let some = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 10, width: 120, height: 45))
            some.placeholder = "Email"
            some.title = "Email address"
            some.errorColor = UIColor.red
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
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblTitle)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(txtPassword)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(txtUserName)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnLogin)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblErrorMessage)

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(screenHeight)

            self.subViewsOf(types: [.button, .label], recursive: true).forEach { (some) in
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                some.autoLayout.marginToSuperVerticalStackView(trailing: AppSizes.Margins.defaultMargin,
                                                               leading: AppSizes.Margins.defaultMargin)
            }
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
            let changed1 = txtPassword.rx.text.orEmpty.map { $0.count >= 1 }//.distinctUntilChanged()
            let changed2    = txtUserName.rx.text.orEmpty.map({ $0.count >= 1 })//.distinctUntilChanged()
            let isButtonEnabled = Observable.combineLatest(changed1, changed2) { $0 || $1 }
            isButtonEnabled.asObservable().bind { (some) in
                print("changed \(some)")
            }.disposed(by: disposeBag)
        }

        // This will notify us when something has changed on the textfield
        @objc func textFieldDidChange(_ textfield: UITextField) {
            if let floatingLabelTextField = txtUserName as? SkyFloatingLabelTextField {
                rxUserName.onNext(floatingLabelTextField.text)
            } else if let floatingLabelTextField = txtPassword as? SkyFloatingLabelTextField {
                rxPassword.onNext(floatingLabelTextField.text)
            }
        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        func setupWith(someStuff viewModel: VM.CarTrackLogin.ScreenState.ViewModel) {
           // subTitle = viewModel.subTitle
        }

        func setupWith(screenInitialState viewModel: VM.CarTrackLogin.ScreenInitialState.ViewModel) {
            lblTitle.text = viewModel.title
            txtUserName.text = viewModel.userName
            txtPassword.text = viewModel.password
            screenLayout = viewModel.screenLayout
        }

        private func setErrorMessage(_ message: String, forField: SkyFloatingLabelTextField) {
            forField.errorMessage = message
        }

        var screenLayout: E.CarTrackLoginView.ScreenLayout = .enterUserCredentials {
            didSet {
                switch screenLayout {
                case .enterUserCredentials:
                    btnLogin.fadeTo(0.8)
                case .wrongPassword(errorMessage: let errorMessage):
                    lblErrorMessage.text = errorMessage
                case .invalidEmailFormat(errorMessage: let errorMessage):
                    setErrorMessage(errorMessage, forField: txtUserName)
                    setErrorMessage("", forField: txtPassword)
                case .invalidPasswordFormat(errorMessage: let errorMessage):
                    _ = 1
                case .invalidEmailFormatAndPasswordFormat(errorMessage1: let errorMessage1, errorMessage2: let errorMessage2):
                    _ = 1
                }
            }
        }
    }
}

// MARK: - Events capture

extension V.CarTrackLoginView {
    var rxBtnLoginTap: Observable<Void> { btnLogin.rx.tapSmart(disposeBag) }
}
