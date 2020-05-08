//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

extension VC {

    public class MVVMSampleView_ViewController : GenericView, MVVMSampleView_ViewControllerProtocol {

        var viewModel: MVVMSampleView_ViewModelProtocol?
        lazy var viewModelView: MVVMSampleView_ViewProtocol = {
            let some = V.MVVMSampleView_View()
            self.view.addSubview(some)
            let margin : CGFloat = 50
            some.rjsALayouts.setMarginFromSuperview(top: margin, bottom: margin, left: margin, right: margin) 
            return some
        }()
  
        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            rxSetup()
            prepareLayout()
        }
        
        func rxSetup() {
            
            // Activity indicator
            viewModel?.rxPublishSubject_loading
                .debug("rxPublishSubject_loading")
                .bind(to: self.rx.isAnimating)
                .disposed(by: disposeBag)
            
            viewModel?.rxPublishRelay_needsToUpdate.asSignal()
                .debug("rxPublishRelay_needsToUpdate")
                .emit(onNext: { [weak self] _ in
                    self?.viewModel?.configure(view: self!.viewModelView)
                })
                .disposed(by: disposeBag)
            
            // Messages to display
            viewModel?.rxPublishRelay_genericMessages.asSignal()
                .debug("rxPublishRelay_genericMessages")
                .emit(onNext: { [weak self] some in
                    self?.displayMessage(some.0, type: some.1)
                })
                .disposed(by: disposeBag)
        }
        
        override func prepareLayout() {
            super.prepareLayout()
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            viewModel?.configure(view: viewModelView)
        }
    }
   
}
