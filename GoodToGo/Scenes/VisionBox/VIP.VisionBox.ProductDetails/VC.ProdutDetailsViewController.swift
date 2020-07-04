//
//  VC.ProdutDetailsViewController.swift
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
struct ProdutDetailsViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.ProdutDetailsViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.ProdutDetailsViewController {
        let vc = VC.ProdutDetailsViewController(presentationStyle: .modal)
        //vc.something(viewModel: dashboardVM)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct ProdutDetailsViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return ProdutDetailsViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class ProdutDetailsViewController: BaseGenericViewControllerVIP<V.ProdutDetailsView> {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        private var interactor: ProdutDetailsBusinessLogicProtocol?
        var router: (ProdutDetailsRoutingLogicProtocol &
            ProdutDetailsDataPassingProtocol &
            ProdutDetailsRoutingLogicProtocol)?

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
                interactor?.requestSomething(request: VM.ProdutDetails.Something.Request(userId: ""))

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
            let interactor = I.ProdutDetailsInteractor()
            let presenter  = P.ProdutDetailsPresenter()
            let router     = R.ProdutDetailsRouter()
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
/*
            genericView
                .rxModelSelected
                .log(whereAmI())
                .subscribe(onNext: { /* [router] */ (some) in
                    DevTools.Log.message("Received [\(some)]")
                })
                .disposed(by: disposeBag)

            genericView.rxBtnSample1Tap
                .do(onNext: { [weak self] in
                    self?.router?.routeSomewhereWithDataStore()
                })
                .subscribe()
                .disposed(by: disposeBag)

            genericView.rxBtnSample2Tap
                .do(onNext: { [weak self] in
                    self?.doPrivateStuff()
                })
                .subscribe()
                .disposed(by: disposeBag)
*/
        }

        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.ProdutDetailsViewController {

}

// MARK: Private Misc Stuff

extension VC.ProdutDetailsViewController {
    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    private func doPrivateStuff() {
     //   let request = VM.ProdutDetails.Something.Request(userId:)
       // self.interactor?.requestSomething(request: request)
    }
}

// MARK: DisplayLogicProtocolProtocol

extension VC.ProdutDetailsViewController: ProdutDetailsDisplayLogicProtocol {

    func displaySomething(viewModel: VM.ProdutDetails.Something.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(someStuff: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.ProdutDetails.ScreenInitialState.ViewModel) {
        title = viewModel.title
        // Setting up the view, option 2 : setting the vars one by one
//        genericView.subTitle = viewModel.subTitle
    }
}
