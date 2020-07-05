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
        
        private var interactor: ProductsListBusinessLogicProtocol?
        var router: (ProductsListRoutingLogicProtocol &
            ProductsListDataPassingProtocol &
            ProductsListRoutingLogicProtocol)?
        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            //topGenericView.lazyLoad()
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
            let presenter  = P.ProductsListPresenter()
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

            genericView.rxSelected.asObserver().bind { [weak self] (selected) in
                guard let self = self else { return }
                guard let selected = selected else { return }
                guard self.isVisible else { return }
                let viewModel = VM.ProductsList.ShowProductDetails.Request(product: selected)
                self.interactor?.requestShowProductDetails(viewModel: viewModel)
            }.disposed(by: disposeBag)

            genericView.rxFilter.asObserver().bind { [weak self] (search) in
                guard let self = self else { return }
                guard let search = search else { return }
                guard self.isVisible else { return }
                let viewModel = VM.ProductsList.FilterProducts.Request(search: search)
                self.interactor?.requestFilterProducts(viewModel: viewModel)
            }.disposed(by: disposeBag)
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

extension VC.ProductsListViewController: ProductsListDisplayLogicProtocol {

    func displayShowProductDetails(viewModel: VM.ProductsList.ShowProductDetails.ViewModel) {
        
    }

    func displayFilterProducts(viewModel: VM.ProductsList.FilterProducts.ViewModel) {
        if viewModel.products.count == 0 {
            displayError(viewModel: BaseDisplayLogicModels.Error(title: Messages.noRecords.localised))
        }
        genericView.setupWith(filter: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.ProductsList.ScreenInitialState.ViewModel) {
        if viewModel.products.count == 0 {
            displayError(viewModel: BaseDisplayLogicModels.Error(title: Messages.noRecords.localised))
        }
        genericView.setupWith(screenInitialState: viewModel)
    }
}
