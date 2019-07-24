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
    func presentControllerWith(data:VM.SampleView_ViewModel)
}

extension Router {
    class SampleView_Router: GenericRouter, GenericRouter_Protocol, SampleView_RouterProtocol {

        // PublishRelay model Events
        //private var rxPublishRelay_ShowDetails = PublishRelay<VM.SampleView_ViewModel>()
        private weak var baseView : V.SampleView_View?
        init(viewController: V.SampleView_View) {
            super.init()
            baseView = viewController
            

            /*
            rxPublishRelay_ShowDetails.asObservable()
                .map { data -> V.SampleView_View? in

                }
                .ignoreNil()
                .subscribe(onNext: { [weak self] in  })
                .disposed(by: disposeBag)
            
            rxPublishRelay_dismissView.asSignal()
                .emit(onNext: { _ in generalDismiss() })
                .disposed(by: disposeBag)*/
        }

        private func generalDismiss() {
            baseView?.dismiss(animated: true)
        }
        
        func dismissView() {
            generalDismiss()
        }
                
        func presentControllerWith(data:VM.SampleView_ViewModel) {
            guard let controller = AppDelegate.shared.container.resolve(V.SampleView_View.self) else { return }
            controller.presenter.viewModel = data
            baseView?.present(controller, animated: true, completion: nil)
        }
        
    }
}

