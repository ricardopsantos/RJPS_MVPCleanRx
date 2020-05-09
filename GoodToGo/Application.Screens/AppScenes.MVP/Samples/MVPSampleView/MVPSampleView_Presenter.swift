//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
import Swinject
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol MVPSampleView_PresenterProtocol: class {
    var generic: GenericPresenter_Protocol? { get }        // Mandatory in ALL Presenters
    var genericView: GenericView? { get }                  // Mandatory in ALL Presenters
    var viewModel: VM.MVPSampleView_ViewModel? { get set } // Mandatory in ALL Presenters
    var router: MVPSampleView_RouterProtocol! { get }      // Mandatory in ALL Presenters
    
    func userDidTryToLoginWith(user: String, password: String)
}

protocol MVPSampleView_ViewProtocol: class {
    func updateViewWith(message: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class MVPSampleView_Presenter: GenericPresenter {
        weak var generic: GenericPresenter_Protocol?
        weak var genericView: GenericView?
        weak var view: MVPSampleView_ViewProtocol!
        var viewModel: VM.MVPSampleView_ViewModel? { didSet { AppLogger.log(appCode: .vmChanged); viewModelChanged() } }
        var router: MVPSampleView_RouterProtocol!

        var sample_UseCase: Sample_UseCaseProtocol!
    }
}

//
// MARK: - Presenter Protocol
//

extension P.MVPSampleView_Presenter: MVPSampleView_PresenterProtocol {
    
    func userDidTryToLoginWith(user: String, password: String) {
        AppLogger.log("\(user) | \(password)")
        genericView?.setActivityState(true)
        sample_UseCase.operation1(canUseCache: false) { [weak self] (result) in
            guard let strongSelf = self else { AppLogger.log(appCode: .referenceLost); return }
            strongSelf.genericView?.setActivityState(false)
            switch result {
            case .success(let some): strongSelf.viewModel = VM.MVPSampleView_ViewModel(someString: "\(some)")
            case .failure          : strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
            }
        }
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.MVPSampleView_Presenter: GenericPresenter_Protocol {
    func view_deinit() { }
    func loadView() { rxSetup() }
    func viewDidAppear() { }
    func viewDidLoad() { }
    func viewWillAppear() { }
    
    func rxSetup() { }

}

//
// MARK: - Presenter Private Stuff
//

extension P.MVPSampleView_Presenter {
    
    private func viewModelChanged() {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm: VM.MVPSampleView_ViewModel?) {
        guard viewModel != nil else { AppLogger.log(appCode: .ignored); return }
        view.updateViewWith(message: viewModel!.someString)
    }

}
