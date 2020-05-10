//
//  UIButton+Rx.swift
//  Extensions
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift

extension Reactive where Base == UIButton {

    // Same as rx.Tap but avoid double repeated taps
    public func tapSmart(_ disposeBag: DisposeBag, _ timeout: TimeInterval = 1) -> Observable<Void> {
        return tap
            .do(onNext: { [base] _ in
                base.isUserInteractionEnabled = false
                Observable<Void>
                    .just(())
                    .delay(timeout, scheduler: MainScheduler.instance)
                    .do(onNext: {
                        base.isUserInteractionEnabled = true
                    })
                    .subscribe()
                    .disposed(by: disposeBag)
            })
    }
}
