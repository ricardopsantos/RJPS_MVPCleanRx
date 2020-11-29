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
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import AppResources
import BaseUI

// MARK: - Preview

@available(iOS 13.0.0, *)
struct DevScreenViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.DevScreenViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.DevScreenViewController {
        let vc = VC.DevScreenViewController()
        //vc.something(viewModel: dashboardVM)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct DevScreenViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return DevScreenViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class DevScreenViewController: BaseGenericViewControllerVIP<V.DevScreenView> {
        private var interactor: DevScreenBusinessLogicProtocol?
        var router: (DevScreenRoutingLogicProtocol &
            DevScreenDataPassingProtocol &
            DevScreenRoutingLogicProtocol)?

        private lazy var topGenericView: TopBar = {
            UIKitFactory.topBar(baseController: self, usingSafeArea: false)
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
                DispatchQueue.executeOnce(token: "\(VC.DevScreenViewController.self).info") {
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
            let interactor = I.DevScreenInteractor()
            let presenter  = P.DevScreenPresenter()
            let router     = R.DevScreenRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
            router.dataStore = interactor
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
            topGenericView.setTitle("DevScreen")
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

extension VC.DevScreenViewController {

}

// MARK: Private Misc Stuff

private extension VC.DevScreenViewController {

}

// MARK: DisplayLogicProtocol

extension VC.DevScreenViewController: DevScreenDisplayLogicProtocol {

    func displaySomeStuff(viewModel: VM.DevScreen.SomeStuff.ViewModel) {
        // Setting up the view, option 1 : passing the view model
    }

    func displayScreenInitialState(viewModel: VM.DevScreen.ScreenInitialState.ViewModel) {
        title = viewModel.title
    }
}
