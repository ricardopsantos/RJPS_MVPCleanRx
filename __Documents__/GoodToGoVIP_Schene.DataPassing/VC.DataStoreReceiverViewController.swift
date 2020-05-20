//
//  VC.DataStoreReceiverViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 20/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
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

// MARK: - Presenter

extension P {
    class DataStoreReceiverPresenter: BasePresenterVIP {
        weak var viewController: (DataStoreReceiverDisplayLogicProtocol)?
        override weak var baseViewController: BaseViewControllerVIPProtocol? {
            return viewController
        }
    }
}

extension P.DataStoreReceiverPresenter: DataStoreReceiverPresentationLogicProtocol { }

// MARK: - View

extension V {
    class DataStoreReceiverView: BaseGenericViewVIP { }
}

// MARK: - ViewController

extension VC {

    class DataStoreReceiverViewController: BaseGenericViewControllerVIP<V.DataStoreReceiverView> {
        private var interactor: DataStoreReceiverBusinessLogicProtocol?
        var router: (DataStoreReceiverRoutingLogicProtocol
            & DataStoreReceiverDataPassingProtocol // <<-- DS Sample : Take notice
        )?

        // Order in View life-cycle : 6
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance { interactor?.requestScreenInitialState() }
        }

        // Order in View life-cycle : 1
        override func setup() {
            // This function is called automatically by super BaseGenericView
            let viewController = self
            let interactor = I.DataStoreReceiverInteractor()
            let presenter  = P.DataStoreReceiverPresenter()
            let router     = R.DataStoreReceiverRouter()
            viewController.interactor = interactor
            viewController.router    = router
            interactor.presenter     = presenter
            presenter.viewController = viewController
            router.viewController    = viewController
            router.dsToBeSetted      = interactor      // <<-- DS Sample : Take notice
        }

    }
}

// MARK: DisplayLogicProtocolProtocol

extension VC.DataStoreReceiverViewController: DataStoreReceiverDisplayLogicProtocol { }