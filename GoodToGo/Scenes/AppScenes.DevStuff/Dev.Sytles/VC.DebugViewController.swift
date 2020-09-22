//
//  GoodToGo
//
//  Created by Ricardo Santos
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
struct DebugViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.DebugViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.DebugViewController {
        let vc = VC.DebugViewController()
        //vc.something(viewModel: dashboardVM)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct DebugViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return DebugViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class DebugViewController: BaseGenericViewControllerVIP<V.DebugView> {
        private var interactor: DebugBusinessLogicProtocol?
        var router: (DebugRoutingLogicProtocol &
            DebugDataPassingProtocol &
            DebugRoutingLogicProtocol)?

        private lazy var topGenericView: TopBar = {
            let some = TopBar()
            some.injectOn(viewController: self, usingSafeArea: false)
            return some
        }()

        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
            self.title = "DevScreen"
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            if DevTools.onSimulator {
                DispatchQueue.executeOnce(token: "\(VC.DebugViewController.self).info") {
                    let message = """
                    Debug Screen to help developers to know:
                        - Installed Feature Flags
                        - App available fonts
                        - App available colors
                        - App available alert styles
                        - App UI components
                        - ...
                    """
                    DevTools.makeToast(message, duration: 5)
                }
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                //bottomBar.injectOn(viewController: self, usingSafeArea: false)
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
            let interactor = I.DebugInteractor()
            let presenter  = P.DebugPresenter()
            let router     = R.DebugRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
            router.dsStyles = interactor
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

extension VC.DebugViewController {

}

// MARK: Private Misc Stuff

private extension VC.DebugViewController {

}

// MARK: DisplayLogicProtocol

extension VC.DebugViewController: DebugDisplayLogicProtocol {

    func displaySomeStuff(viewModel: VM.Debug.SomeStuff.ViewModel) {
        // Setting up the view, option 1 : passing the view model
    }

    func displayScreenInitialState(viewModel: VM.Debug.ScreenInitialState.ViewModel) {
        title = viewModel.title
    }
}
