//
//  File.swift
//  UIBase
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
//
import Domain
import UIBase

extension ObservableType {
    func subscribeWithLoading<T>(presenter: BasePresentationLogicProtocol,
                                 onNext: ((T) -> Void)? = nil,
                                 onError: ((Error) -> Void)? = nil,
                                 onCompleted: (() -> Void)? = nil,
                                 onDisposed: (() -> Void)? = nil) -> Disposable where Self.E == T {
        weak var weakPresenter = presenter
        let response = LoadingModel.Response(isLoading: true, message: "")
        weakPresenter?.presentLoading(response: response)
        return subscribe(onNext: { element in
            DispatchQueue.main.async {
                let response = LoadingModel.Response(isLoading: false, message: "")
                weakPresenter?.presentLoading(response: response)
                onNext?(element)
            }
        }, onError: { (error) in
            let response = LoadingModel.Response(isLoading: false, message: "")
            weakPresenter?.presentLoading(response: response)
            let errorResponse = ErrorModel.Response(error: error)
            weakPresenter?.presentError(response: errorResponse)
            onError?(error)
        }, onCompleted: {
            let response = LoadingModel.Response(isLoading: false, message: "")
            weakPresenter?.presentLoading(response: response)
            onCompleted?()
        }, onDisposed: {
            onDisposed?()
        })
    }
}
/*
extension PrimitiveSequenceType where TraitType == MaybeTrait {
    func subscribeWithLoading<T>(presenter: BasePresentationLogicProtocol,
                                 onSuccess: ((T) -> Void)? = nil,
                                 onError: ((Error) -> Void)? = nil) -> Disposable where ElementType == T {
        weak var weakPresenter = presenter
        let response = LoadingModel.Response(isLoading: true, message: "")
        weakPresenter?.presentLoading(response: response)
        return subscribe(onSuccess: { element in
            onSuccess?(element)
        }, onError: { error in
            let response = LoadingModel.Response(isLoading: false, message: "")
            weakPresenter?.presentLoading(response: response)
            #warning("comentado")
            //let errorResponse = LoadingModel.Response(error: error)
            //weakPresenter?.presentError(response: errorResponse)
            onError?(error)
        }, onCompleted: {
            let response = LoadingModel.Response(isLoading: false, message: "")
            weakPresenter?.presentLoading(response: response)
        })
    }
}*/

public protocol StylableProtocol: class {

}

open class StylableView: UIView, StylableProtocol {

}
