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

        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            if DevTools.onSimulator {
                DispatchQueue.executeOnce(token: "\(VC.CategoriesPickerViewController.self).info") {
                    let message = """
                    Exam: Vision Box

                    Check `__Documents__/exams/VisionBox.Report/README.md` for more details
                    """
                    DevTools.makeToast(message, duration: 5)
                }
            }
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

        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

            genericView.rxCategoryTap.asObserver().bind { [weak self] (category) in
                guard let self = self else { return }
                guard self.isVisible else { return }
                guard let category = category else { return }
                let request = VM.CategoriesPicker.CategoryChange.Request(category: category)
                self.interactor?.requestCategoryChange(request: request)
            }.disposed(by: disposeBag)
        }

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

}

// MARK: DisplayLogicProtocolProtocol

extension VC.CategoriesPickerViewController: CategoriesPickerDisplayLogicProtocol {

    func displayCategoryChange(viewModel: VM.CategoriesPicker.CategoryChange.ViewModel) {
        router?.routeToCategoriesList()
    }

    func displayScreenInitialState(viewModel: VM.CategoriesPicker.ScreenInitialState.ViewModel) {

    }
}
