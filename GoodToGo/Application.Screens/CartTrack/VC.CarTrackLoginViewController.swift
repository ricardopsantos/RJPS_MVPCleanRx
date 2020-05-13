//
//  VC.CarTrackLoginViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import AppResources
import UIBase

extension VC {

    class CarTrackLoginViewController: BaseGenericViewControllerVIP<V.CarTrackLoginView> {
        private var interactor: CarTrackLoginBusinessLogicProtocol?
        var router: (CarTrackLoginRoutingLogicProtocol &
            CarTrackLoginDataPassingProtocol &
            CarTrackLoginRoutingLogicProtocol)?

        //
        // MARK: View lifecycle
        //

        // Order in View life-cycle : 2
        override func loadView() {
            super.loadView()
        }

        // Order in View life-cycle : 4
        override func viewDidLoad() {
            super.viewDidLoad()
        }

        // Order in View life-cycle : 6
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                interactor?.requestScreenInitialState()
            }
        }

        // Order in View life-cycle : 9
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }

        //
        // MARK: Dark Mode
        //

        // Order in View life-cycle : 8
        public override func setupColorsAndStyles() {
            super.setupColorsAndStyles()
            // Setup UI on dark mode (if needed)
        }

        //
        // MARK: Mandatory methods
        //

        // Order in View life-cycle : 1
        override func setup() {
            // This function is called automatically by super BaseGenericView
            let viewController = self
            let interactor = I.CarTrackLoginInteractor()
            let presenter  = P.CarTrackLoginPresenter()
            let router     = R.CarTrackLoginRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
            router.dsCarTrackLogin = interactor
        }

        // Order in View life-cycle : 5
        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
        }

        // Order in View life-cycle : 3
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

            Observable.combineLatest(genericView.rxPassword, genericView.rxUserName).bind { [weak self] (s1, s2) in
                guard let s1 = s1, let s2 = s2 else { return }
                let request = VM.CarTrackLogin.ScreenState.Request(userName: s1, password: s2)
                self?.interactor?.requestScreenState(request: request)
            }.disposed(by: disposeBag)

            genericView.rxBtnLoginTap
                .do(onNext: { [weak self] in
                    self?.router?.routeToTemplateWithParentDataStore()
                })
                .subscribe()
                .disposed(by: disposeBag)

        }

        // Order in View life-cycle : 7
        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.CarTrackLoginViewController {
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    public func somePublicStuff() {
        // Do some public stuff
    }
}

// MARK: Private Misc Stuff

extension VC.CarTrackLoginViewController {

    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    private func validateNextButtonEnabled() {
        let request = VM.CarTrackLogin.ScreenState.Request(userName: "userName", password: "password")
        self.interactor?.requestScreenState(request: request)
    }
}

// MARK: DisplayLogicProtocolProtocol

extension VC.CarTrackLoginViewController: CarTrackLoginDisplayLogicProtocol {

    func displayScreenState(viewModel: VM.CarTrackLogin.ScreenState.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(someStuff: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.CarTrackLogin.ScreenInitialState.ViewModel) {
        genericView.setupWith(screenInitialState: viewModel)
    }
}
