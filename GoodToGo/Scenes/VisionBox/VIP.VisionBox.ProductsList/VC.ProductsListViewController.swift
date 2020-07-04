//
//  VC.ProdutsListViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
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

// MARK: - Preview
 
@available(iOS 13.0.0, *)
struct ProdutsListViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.ProductsListViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.ProductsListViewController {
        let vc = VC.ProductsListViewController(presentationStyle: .modal)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct ProdutsListViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return ProdutsListViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class ProductsListViewController: BaseGenericViewControllerVIP<V.ProductsListView> {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        private var interactor: ProdutsListBusinessLogicProtocol?
        var router: (ProdutsListRoutingLogicProtocol &
            ProductsListDataPassingProtocol &
            ProdutsListRoutingLogicProtocol)?

        private lazy var reachabilityView: ReachabilityView = {
           return self.addReachabilityView()
        }()

        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
            reachabilityView.load()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                interactor?.requestScreenInitialState()
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
            let interactor = I.ProdutsListInteractor()
            let presenter  = P.ProdutsListPresenter()
            let router     = R.ProductsListRouter()
            viewController.interactor = interactor
            viewController.router    = router
            interactor.presenter     = presenter
            presenter.viewController = viewController
            router.viewController    = viewController
            router.dsSource          = interactor
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
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

extension VC.ProductsListViewController {

}

// MARK: Private Misc Stuff

extension VC.ProductsListViewController {

}

// MARK: DisplayLogicProtocolProtocol

extension VC.ProductsListViewController: ProdutsListDisplayLogicProtocol {

    func displaySomething(viewModel: VM.ProductsList.Something.ViewModel) {

    }

    func displayScreenInitialState(viewModel: VM.ProductsList.ScreenInitialState.ViewModel) {
        genericView.setupWith(screenInitialState: viewModel)
    }
}
