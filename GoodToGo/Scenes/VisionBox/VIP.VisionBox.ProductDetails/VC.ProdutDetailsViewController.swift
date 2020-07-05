//
//  VC.ProductDetailsViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
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
struct ProductDetailsViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.ProductDetailsViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.ProductDetailsViewController {
        let vc = VC.ProductDetailsViewController(presentationStyle: .modal)
        vc.interactor?.requestScreenInitialState()
        return vc
    }
}

@available(iOS 13.0.0, *)
struct ProductDetailsViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return ProductDetailsViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class ProductDetailsViewController: BaseGenericViewControllerVIP<V.ProductDetailsView> {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        fileprivate var interactor: ProductDetailsBusinessLogicProtocol?
        var router: (ProductDetailsRoutingLogicProtocol &
            ProductDetailsDataPassingProtocol &
            ProductDetailsRoutingLogicProtocol)?

        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
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
            let interactor = I.ProductDetailsInteractor()
            let presenter  = P.ProductDetailsPresenter()
            let router     = R.ProductDetailsRouter()
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

extension VC.ProductDetailsViewController {

}

// MARK: Private Misc Stuff

extension VC.ProductDetailsViewController {

}

// MARK: DisplayLogicProtocolProtocol

extension VC.ProductDetailsViewController: ProductDetailsDisplayLogicProtocol {

    func displayScreenInitialState(viewModel: VM.ProductDetails.ScreenInitialState.ViewModel) {
        genericView.setupWith(screenInitialState: viewModel)
    }
}
