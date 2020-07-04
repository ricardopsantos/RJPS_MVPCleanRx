//
//  VC.CartTrackMapViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
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

    class CartTrackMapViewController: BaseGenericViewControllerVIP<V.CartTrackMapView> {
        var interactor: CartTrackMapBusinessLogicProtocol?
        var router: (CartTrackMapRoutingLogicProtocol &
            CartTrackMapDataPassingProtocol &
            CartTrackMapRoutingLogicProtocol)?

        //
        // MARK: UI Elements
        //

        private lazy var topGenericView: TopBar = {
            let some = TopBar()
            some.injectOn(viewController: self, usingSafeArea: false)
            some.addDismissButton()
            some.rxSignal_btnDismissTapped
                .asObservable()
                .log(whereAmI())
                .subscribe(onNext: { (_) in
                    self.router?.routeToLogin()
                }).disposed(by: disposeBag)
            return some
        }()

        private lazy var reachabilityView: ReachabilityView = {
           return self.addReachabilityView()
        }()

        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
            self.title = "Map"
           // topGenericView.lazyLoad()
            topGenericView.setTitle(self.title!)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                reachabilityView.lazyLoad()
                interactor?.requestScreenInitialState()
                let request = VM.CartTrackMap.MapData.Request()
                interactor?.requestMapData(request: request)
            }
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }

        //
        // MARK: Dark Mode
        //

        public override func setupColorsAndStyles() {
            //super.setupColorsAndStyles()
            // Setup UI on dark mode (if needed)
        }

        //
        // MARK: Mandatory methods
        //

        override func setup() {
            // This function is called automatically by super BaseGenericView
            let viewController = self
            let interactor = I.CartTrackMapInteractor()
            let presenter  = P.CartTrackMapPresenter()
            let router     = R.CartTrackMapRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
            genericView.rxFilter.asObserver().bind { [weak self] (search) in
                guard let self = self else { return }
                guard let search = search else { return }
                guard self.isVisible else { return }
                let viewModel = VM.CartTrackMap.MapDataFilter.Request(filter: search)
                self.interactor?.requestMapDataFilter(viewModel: viewModel)
            }.disposed(by: disposeBag)
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.CartTrackMapViewController {

}

// MARK: Private Misc Stuff

extension VC.CartTrackMapViewController {

}

// MARK: DisplayLogicProtocolProtocol

extension VC.CartTrackMapViewController: CartTrackMapDisplayLogicProtocol {

    func displayMapDataFilter(viewModel: VM.CartTrackMap.MapDataFilter.ViewModel) {
        genericView.setupWith(mapDataFilter: viewModel)
    }

    func displayMapData(viewModel: VM.CartTrackMap.MapData.ViewModel) {
        genericView.setupWith(mapData: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel) {

    }
}