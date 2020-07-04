//
//  VC.CategoriesPickerViewController.swift
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
struct CategoriesPickerViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.CategoriesPickerViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.CategoriesPickerViewController {
        let vc = VC.CategoriesPickerViewController(presentationStyle: .modal)
        //vc.something(viewModel: dashboardVM)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct CategoriesPickerViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return CategoriesPickerViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class CategoriesPickerViewController: BaseGenericViewControllerVIP<V.CategoriesPickerView> {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        private var interactor: CategoriesPickerBusinessLogicProtocol?
        var router: (CategoriesPickerRoutingLogicProtocol &
            CategoriesPickerDataPassingProtocol &
            CategoriesPickerRoutingLogicProtocol)?

        private lazy var reachabilityView: ReachabilityView = {
           return self.addReachabilityView()
        }()

        //
        // MARK: View lifecycle
        //

        // Order in View life-cycle : 2
        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
            reachabilityView.load()
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
                interactor?.requestSomething(request: VM.CategoriesPicker.Something.Request(userId: ""))

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
            let interactor = I.CategoriesPickerInteractor()
            let presenter  = P.CategoriesPickerPresenter()
            let router     = R.CategoriesPickerRouter()
            viewController.interactor = interactor
            viewController.router    = router
            interactor.presenter     = presenter
            presenter.viewController = viewController
            router.viewController    = viewController
            router.dsSource          = interactor
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

        // Order in View life-cycle : 7
        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.CategoriesPickerViewController {

}

// MARK: Private Misc Stuff

extension VC.CategoriesPickerViewController {
    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    private func doPrivateStuff() {
       // let userId = genericView.title
       // let request = VM.CategoriesPicker.Something.Request(userId: userId)
       // self.interactor?.requestSomething(request: request)
    }
}

// MARK: DisplayLogicProtocolProtocol

extension VC.CategoriesPickerViewController: CategoriesPickerDisplayLogicProtocol {

    func displaySomething(viewModel: VM.CategoriesPicker.Something.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(someStuff: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.CategoriesPicker.ScreenInitialState.ViewModel) {
       // title = viewModel.title
        // Setting up the view, option 2 : setting the vars one by one
      //  genericView.subTitle = viewModel.subTitle
    }
}
