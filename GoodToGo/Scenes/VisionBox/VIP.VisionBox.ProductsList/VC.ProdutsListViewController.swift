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
    func updateUIViewController(_ uiViewController: VC.ProdutsListViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.ProdutsListViewController {
        let vc = VC.ProdutsListViewController(presentationStyle: .modal)
        //vc.something(viewModel: dashboardVM)
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

    class ProdutsListViewController: BaseGenericViewControllerVIP<V.ProdutsListView> {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        private var interactor: ProdutsListBusinessLogicProtocol?
        var router: (ProdutsListRoutingLogicProtocol &
            ProdutsListDataPassingProtocol &
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
                interactor?.requestSomething(request: VM.ProdutsList.Something.Request(userId: ""))

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
            let router     = R.ProdutsListRouter()
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

extension VC.ProdutsListViewController {

}

// MARK: Private Misc Stuff

extension VC.ProdutsListViewController {
    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    private func doPrivateStuff() {
       // let userId = genericView.subTitle
        //let request = VM.ProdutsList.Something.Request(userId: userId)
        //self.interactor?.requestSomething(request: request)
    }
}

// MARK: DisplayLogicProtocolProtocol

extension VC.ProdutsListViewController: ProdutsListDisplayLogicProtocol {

    func displaySomething(viewModel: VM.ProdutsList.Something.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(someStuff: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.ProdutsList.ScreenInitialState.ViewModel) {
        title = viewModel.title
        // Setting up the view, option 2 : setting the vars one by one
       // genericView.subTitle = viewModel.subTitle
    }
}
