//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SampleView_RouterProtocol: class {
    func dismissView()
    var rxPublishRelay_dismissView: PublishRelay<Void> { get } // PublishRelay model Events

    func presentControllerWith(data:VM.SampleView_ViewModel)
}

extension Router {
    class SampleView_Router: GenericRouter, GenericRouter_Protocol, SampleView_RouterProtocol {

        // PublishRelay model Events
        private var rxPublishRelay_ShowDetails = PublishRelay<VM.SampleView_ViewModel>()
        private weak var baseView : V.SampleView_View?
        init(viewController: V.SampleView_View) {
            super.init()
            baseView = viewController
            
            func generalDismiss() {
                baseView?.dismiss(animated: true)
            }
            
            rxPublishRelay_ShowDetails.asObservable()
                .map { data -> V.SampleView_View? in
                    guard let controller = AppDelegate.shared.container.resolve(V.SampleView_View.self) else { return nil }
                    controller.presenter.viewModel = data
                    return controller
                }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in self?.baseView?.present($0, animated: true, completion: nil) })
                .disposed(by: disposeBag)
            
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)
        }

        func dismissView() {
            rxPublishRelay_dismissView.accept(())
        }
                
        func presentControllerWith(data:VM.SampleView_ViewModel) {
            rxPublishRelay_ShowDetails.accept(data)
        }
        
    }
}

