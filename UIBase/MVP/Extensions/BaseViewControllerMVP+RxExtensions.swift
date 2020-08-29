//
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RxCocoa
import RxSwift
import RJPSLib_Base

public extension Reactive where Base: BaseViewControllerMVP {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    var isAnimating: Binder<Bool> {

        /*
         public var rxPublishSubject_loading     : PublishSubject<Bool> = PublishSubject()
         ...
         viewModel?.rxPublishSubject_loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
 */
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.view.rjs.startActivityIndicator()
            } else {
                vc.view.rjs.stopActivityIndicator()
            }
        })
    }
}
