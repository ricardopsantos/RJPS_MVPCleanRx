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
        private var interactor: CartTrackMapBusinessLogicProtocol?
        var router: (CartTrackMapRoutingLogicProtocol &
            CartTrackMapDataPassingProtocol &
            CartTrackMapRoutingLogicProtocol)?

        //
        // MARK: UI Elements
        //

        private lazy var topGenericView: TopBar = {
            let some = TopBar()
            some.injectOn(viewController: self)
            some.setTitle(Messages.welcome.localised)
            return some
        }()

        //
        // MARK: View lifecycle
        //

        // Order in View life-cycle : 2
        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
            self.title = "Map"
            topGenericView.lazyLoad()
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
                let request = VM.CartTrackMap.MapData.Request()
                interactor?.requestMapData(request: request)
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
            let interactor = I.CartTrackMapInteractor()
            let presenter  = P.CartTrackMapPresenter()
            let router     = R.CartTrackMapRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
        }

        // Order in View life-cycle : 5
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

        // Order in View life-cycle : 3
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {
            #warning("Add reachability support")
        }

        // Order in View life-cycle : 7
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
