//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RJPSLib

public protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

public extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

public extension ObservableType {
    
    /**
     Filters the source observable sequence using a trigger observable sequence producing Bool values.
     Elements only go through the filter when the trigger has not completed and its last element was true. If either source or trigger error's, then the source errors.
     - parameter trigger: Triggering event sequence.
     - returns: Filtered observable sequence.
     */
    func filter(if trigger: Observable<Bool>) -> Observable<Element> {
        return withLatestFrom(trigger) { (myValue, triggerValue) -> (Element, Bool) in
            return (myValue, triggerValue)
            }
            .filter { (_, triggerValue) -> Bool in
                return triggerValue == true
            }
            .map { (myValue, _) -> Element in
                return myValue
        }
        
        /*
 
         button.rx.tap.filter(if: enableButtons)
         .subscribe(onNext: { /* do one thing when enableButtons emits true */ }
         .disposed(by: bag)
         
         button.rx.tap.filter(if: enableButtons.map { !$0 })
         .subscribe(onNext: { /* do other thing when enable buttons emits false*/ }
         .disposed(by: bag)
 
 */
    }
}

extension Reactive where Base: GenericView {
    
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
