//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
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
struct ___VARIABLE_sceneName___ViewController_UIViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: VC.___VARIABLE_sceneName___ViewController, context: Context) { }
    func makeUIViewController(context: Context) -> VC.___VARIABLE_sceneName___ViewController {
        let vc = VC.___VARIABLE_sceneName___ViewController()
        vc.interactor?.requestScreenInitialState()
        return vc
    }
}

@available(iOS 13.0.0, *)
struct ___VARIABLE_sceneName___ViewController_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return ___VARIABLE_sceneName___ViewController_UIViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension VC {

    class ___VARIABLE_sceneName___ViewController: BaseGenericViewControllerVIP<V.___VARIABLE_sceneName___View> {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
        fileprivate var interactor: ___VARIABLE_sceneName___BusinessLogicProtocol?
        var router: (___VARIABLE_sceneName___RoutingLogicProtocol &
            ___VARIABLE_sceneName___DataPassingProtocol &
            ___VARIABLE_sceneName___RoutingLogicProtocol)?

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
            if DevTools.onSimulator {
                DispatchQueue.executeOnce(token: "\(VC.___VARIABLE_sceneName___ViewController.self).info") {
                    let message = """
                    Personal VIP Template. Contains already UI elements ready to use/change/delete.
                    """
                    DevTools.makeToast(message, duration: 5)
                }
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                interactor?.requestScreenInitialState()
                interactor?.requestSomething(request: VM.___VARIABLE_sceneName___.Something.Request(userId: ""))

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
            let interactor = I.___VARIABLE_sceneName___Interactor()
            let presenter  = P.___VARIABLE_sceneName___Presenter()
            let router     = R.___VARIABLE_sceneName___Router()
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

        }

        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.___VARIABLE_sceneName___ViewController {

}

// MARK: Private Misc Stuff

private extension VC.___VARIABLE_sceneName___ViewController {
    #warning("THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE")
    private func doPrivateStuff() {
        let userId = genericView.subTitle
        let request = VM.___VARIABLE_sceneName___.Something.Request(userId: userId)
        self.interactor?.requestSomething(request: request)
    }
}

// MARK: DisplayLogicProtocol

extension VC.___VARIABLE_sceneName___ViewController: ___VARIABLE_sceneName___DisplayLogicProtocol {

    func displaySomething(viewModel: VM.___VARIABLE_sceneName___.Something.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(someStuff: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.___VARIABLE_sceneName___.ScreenInitialState.ViewModel) {
        title = viewModel.title
        // Setting up the view, option 2 : setting the vars one by one
        genericView.subTitle = viewModel.subTitle
    }
}
