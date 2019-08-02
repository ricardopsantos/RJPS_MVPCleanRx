//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

extension VC {

    public class Pet_ViewController : GenericView, Pet_ViewControllerProtocol {

        var viewModel: Pet_ViewModelProtocol?
        lazy var viewModelView: Pet_ViewProtocol = {
            let some = V.Pet_View()
            self.view.addSubview(some)
            let margin : CGFloat = 50
            some.rjsALayouts.setMarginFromSuper(top: margin, bottom: margin, left: margin, right: margin)
            return some
        }()
  
        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            setupBindings()
            prepareLayout()
        }
        
        func setupBindings() {
            viewModel?.rxPublishSubject_loading
                .debug("rxPublishSubject_loading")
                .bind(to: self.rx.isAnimating)
                .disposed(by: disposeBag)
            
            viewModel?.rxPublishRelay_needsToUpdate.asSignal()
                .debug("rxPublishRelay_needsToUpdate")
                .emit(onNext: { [weak self] some in
                    self?.viewModel?.configure(view: self!.viewModelView)
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
