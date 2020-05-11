//
//  BaseGenericViewController.swift
//  UIBase
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import UIBase
import Designables
import DevTools

class BaseViewControllerVIP: UIViewController, BaseDisplayLogicProtocol {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func displayStatus(viewModel: StatusModel) {
        DevTools.makeToast(viewModel.message, isError: false)
    }

    func displayLoading(viewModel: LoadingModel) {
        DevTools.makeToast(viewModel.message, isError: false)
    }

    func displayError(viewModel: ErrorModel) {
        DevTools.makeToast(viewModel.message, isError: true)
    }

    func setupColorsAndStyles() {

    }
}

class BaseGenericViewControllerVIP<T: StylableView>: BaseViewControllerVIP {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var disposeBag = DisposeBag()
    var firstAppearance: Bool = true
    var genericView: T { return view as! T }
    override func loadView() {
        super.loadView()
        view = T()
        setupViewUIRx()
    }

    func setup() {
        fatalError("override me")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewIfNeed()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUIRx()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearance = false
    }

    func setupViewIfNeed() {
        fatalError("Override me")
    }

    func setupNavigationUIRx() {
        fatalError("Override me")
    }

    func setupViewUIRx() {
        fatalError("override me")
    }
}
