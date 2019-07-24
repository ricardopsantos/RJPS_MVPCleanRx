//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
//MARK: Presenter_Protocol & View_Protocol
//

protocol SampleView_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol?   { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?                 { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.SampleView_ViewModel?     { get set } // Mandatory in ALL Presenters
    var router      : SampleView_RouterProtocol!   { get }     // Mandatory in ALL Presenters
    
    func userDidTryToLoginWith(user:String, password:String)
    var rxPublishRelay_dismissView: PublishRelay<Void> { get } // PublishRelay model Events

}

protocol SampleView_ViewProtocol : class {

}

//
//MARK: Presenter Declaration
//

extension Presenter {
    class SampleView_Presenter : GenericPresenter {
        weak var generic      : GenericPresenter_Protocol?
        weak var genericView  : GenericView?
        weak var view   : SampleView_ViewProtocol!
        var viewModel   : VM.SampleView_ViewModel? { didSet { AppLogs.DLog(code: .vmChanged); viewModelChanged() } }
        var router      : SampleView_RouterProtocol!

        var sampleA_UseCase : SampleA_UseCaseProtocol!
        var sampleB_UseCase : SampleB_UseCaseProtocol!
    }
}

//
//MARK: Presenter Protocol
//

extension P.SampleView_Presenter : SampleView_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
    
    func userDidTryToLoginWith(user: String, password: String) {
       
    }
}


//
//MARK: GenericPresenter_Protocol
//

extension P.SampleView_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void { }
    func viewWillAppear() -> Void { }
}

//
//MARK: Presenter Private Stuff
//

extension P.SampleView_Presenter {
    
    private func viewModelChanged() -> Void {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm:VM.SampleView_ViewModel?) -> Void {
        guard viewModel != nil else { AppLogs.DLog(code: .ignored); return }
        //view.viewDataToScreen(some: viewModel!)
        //downloadImage(imageURL: viewModel!.user.avatarUrl!, onFail: AppImages.notFound) { [weak self] (image) -> (Void) in
        //    self?.view.setAvatarWith(image: image!)
        //}
    }

}
