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
import Domain

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol MVPSampleView_PresenterProtocol: class {
    var generic: BasePresenterVMPProtocol? { get }          // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get } // Mandatory in ALL Presenters
    var viewModel: VM.MVPSampleView_ViewModel? { get set }  // Mandatory in ALL Presenters
    var router: MVPSampleView_RouterProtocol! { get }       // Mandatory in ALL Presenters
    
    func userDidTryToLoginWith(user: String, password: String)
}

protocol MVPSampleView_ViewProtocol: class {
    func updateViewWith(message: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class MVPSampleView_Presenter: BasePresenterMVP {
        weak var generic: BasePresenterVMPProtocol?
        weak var genericView: BaseViewControllerMVPProtocol?
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
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            self.genericView?.setActivityState(false)
            switch result {
            case .success(let some): self.viewModel = VM.MVPSampleView_ViewModel(someString: "\(some)")
            case .failure          : self.genericView?.displayMessage(Messages.pleaseTryAgainLater.localised, type: .error)
            }
        }
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.MVPSampleView_Presenter: BasePresenterVMPProtocol {
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
