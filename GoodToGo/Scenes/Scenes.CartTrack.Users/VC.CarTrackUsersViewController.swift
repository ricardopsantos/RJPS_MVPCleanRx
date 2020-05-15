//
//  VC.CarTrackUsersViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/05/2020.
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

    class CarTrackUsersViewController: BaseGenericViewControllerVIP<V.CarTrackUsersView> {
        private var interactor: CarTrackUsersBusinessLogicProtocol?
        var router: (CarTrackUsersRoutingLogicProtocol &
            CarTrackUsersDataPassingProtocol &
            CarTrackUsersRoutingLogicProtocol)?

        //
        // MARK: View lifecycle
        //

        // Order in View life-cycle : 2
        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
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
            //super.setupColorsAndStyles()
            // Setup UI on dark mode (if needed)
        }

        //
        // MARK: Mandatory methods
        //

        // Order in View life-cycle : 1
        override func setup() {
            // This function is called automatically by super BaseGenericView
            let viewController = self
            let interactor = I.CarTrackUsersInteractor()
            let presenter  = P.CarTrackUsersPresenter()
            let router     = R.CarTrackUsersRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
            router.dsCarTrackUsers = interactor
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

            #warning("Add reachability support")
            
            genericView.rxModelSelected
                .subscribe(onNext: { /* [router] */ (some) in
                    AppLogger.log("Received [\(some)]")
                })
                .disposed(by: disposeBag)

            genericView.rxBtnSample1Tap
                .do(onNext: { [weak self] in
                    self?.router?.routeToTemplateWithParentDataStore()
                })
                .subscribe()
                .disposed(by: disposeBag)

            genericView.rxBtnSample2Tap
                .do(onNext: { [weak self] in
                    self?.router?.routeToTemplateWithDataStore()
                })
                .subscribe()
                .disposed(by: disposeBag)

            genericView.rxBtnSample3Tap
                .do(onNext: { [weak self] in
                    self?.doPrivateStuff()
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

extension VC.CarTrackUsersViewController {
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    public func somePublicStuff() {
        // Do some public stuff
    }
}

// MARK: Private Misc Stuff

extension VC.CarTrackUsersViewController {

    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    private func doPrivateStuff() {
        let userId = genericView.subTitle
        let request = VM.CarTrackUsers.SomeStuff.Request(userId: userId)
        self.interactor?.requestSomeStuff(request: request)
    }
}

// MARK: DisplayLogicProtocolProtocol

extension VC.CarTrackUsersViewController: CarTrackUsersDisplayLogicProtocol {

    func displaySomeStuff(viewModel: VM.CarTrackUsers.SomeStuff.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(someStuff: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.CarTrackUsers.ScreenInitialState.ViewModel) {
        title = viewModel.title
        // Setting up the view, option 2 : setting the vars one by one
        genericView.subTitle = viewModel.subTitle
    }
}
