//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib
import RxSwift
import RxCocoa

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

//
//MARK: Presenter_Protocol & View_Protocol
//

protocol SampleRxView_PresenterProtocol_Input { // View -> Presenter
    func userDidTryToLoginWith(user:String, password:String)
}

protocol SampleRxView_PresenterProtocol_Output : SampleRxView_ViewProtocol { // Presenter protocol
    
}

protocol SampleRxView_ProtocolPresenter_IO: SampleRxView_PresenterProtocol_Input, SampleRxView_PresenterProtocol_Output {

}

protocol SampleRxView_PresenterProtocol : class, SampleRxView_ProtocolPresenter_IO {
    var generic     : GenericPresenter_Protocol?   { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?                 { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.SampleRxView_ViewModel?   { get set } // Mandatory in ALL Presenters
    var router      : SampleRxView_RouterProtocol! { get }     // Mandatory in ALL Presenters
}

protocol SampleRxView_ViewProtocol : class {
  //  func updateViewWith(message:String)
}

//
//MARK: Presenter Declaration
//

extension Presenter {
    class SampleRxView_Presenter : GenericPresenter {
        weak var generic      : GenericPresenter_Protocol?
        weak var genericView  : GenericView?
        weak var view   : SampleRxView_ViewProtocol!
        var viewModel   : VM.SampleRxView_ViewModel? { didSet { AppLogs.DLog(code: .vmChanged) } }
        var router      : SampleRxView_RouterProtocol!

        var sample_UseCase : Sample_UseCaseProtocol!
    
        private var _rxPublishRelayAssyncValue1 = PublishRelay<String?>()
        private var _rxPublishRelayAssyncValue2 = PublishRelay<String?>()

    }
}

//
//MARK: Presenter Protocol
//

extension P.SampleRxView_Presenter : SampleRxView_PresenterProtocol {
    
    func userDidTryToLoginWith(user:String, password:String) {
        assertExistsInternetConnection(sender: genericView) { [unowned self] in
            self.doAssyncOperation1(user)
            self.doAssyncOperation2(password)
        }
    }
    
    private func doAssyncOperation1(_ param: String) {
        sample_UseCase.operation1(canUseCache: true) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let some): self._rxPublishRelayAssyncValue1.accept("\(some)")
            case .failure(_)       : self._rxPublishRelayAssyncValue1.accept(nil)
            }
        }
    }
        
    private func doAssyncOperation2(_ param: String) {
        sample_UseCase.operation2(param: param) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let some): self._rxPublishRelayAssyncValue2.accept("\(some)")
            case .failure(_)       : self._rxPublishRelayAssyncValue2.accept(nil)
            }
        }
    }
}


//
//MARK: GenericPresenter_Protocol
//

extension P.SampleRxView_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void {
        setupPresenter()
    }
    func viewWillAppear() -> Void { }
}

extension P.SampleRxView_Presenter  {
    func setupPresenter() {
        
        let _rxSignal1 = _rxPublishRelayAssyncValue1.share(replay: 1, scope: .forever).asSignal(onErrorJustReturn: nil)
        let _rxSignal2 = _rxPublishRelayAssyncValue2.share(replay: 1, scope: .forever).asSignal(onErrorJustReturn: nil)
        
        // Waiting for both responses
        Signal<VM.SampleRxView_ViewModel?>.zip(_rxSignal1, _rxSignal2) { [weak self] in
            guard let self = self else { return nil }
            guard let assyncValue1 = $0, let assyncValue2 = $1 else {
                self.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                return nil
            }
            return VM.SampleRxView_ViewModel(someString: "\(assyncValue1)|\(assyncValue2)")
            }
            .filter { $0 != nil }
            .map { $0! }
            .emit(onNext: {
                self.router.rxPublishRelay_showDetails.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
