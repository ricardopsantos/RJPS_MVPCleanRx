//
//  TokenRefresh.swift
//  WebAPI
//
//  Created by Ricardo Santos on 17/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

/*
func teste() {

}

func testeRefreshToken() {

    let webAPI = WEBAPI()

    webAPI.assyncRequest(param: "AA") { (result) in print(result) }
    webAPI.assyncRequest(param: "BB") { (result) in print(result) }
    webAPI.assyncRequest(param: "CC") { (result) in print(result) }

    DispatchQueue.executeWithDelay(delay: 5) {
        webAPI.invalidateToken()
        webAPI.assyncRequest(param: "DD") { (result) in print(result) }
        webAPI.assyncRequest(param: "EE") { (result) in print(result) }
        webAPI.assyncRequest(param: "FF") { (result) in print(result) }
    }
}

var disposeBag: DisposeBag = DisposeBag()

class WEBAPI {
    private enum TokenState { case valid, invalid, refreshing }
    private let rxTokenState: BehaviorRelay = BehaviorRelay<TokenState>(value: .invalid)
    private let rxTokenValue: BehaviorRelay = BehaviorRelay<String>(value: "")

    func invalidateToken() { DevTools.Log.log("Token invalidated...".uppercased()); rxTokenState.accept(.invalid) }
    func assyncRequest(param: String, result: @escaping(String) -> Void) {

        func requestThatNeedsToken(_ token: String) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { result("assyncRequestA.response.[\(param)][\(token)]") }
        }

        _rxObservableGetTokenRequest.subscribe(onSuccess: { _ in
            requestThatNeedsToken(self.rxTokenValue.value)
        }).disposed(by: disposeBag)
    }

    private var _rxObservableGetTokenRequest: Single<Void> {
        return Single<Void>.create { observer -> Disposable in
            let identifier = "# TokenRefresh: "
            let endSequecence = {
                DevTools.Log.log("\(identifier)Returned valid token.")
                observer(.success(()))
            }
            if self.rxTokenState.value == .valid {
                endSequecence()
            } else {
                if self.rxTokenState.value == .refreshing {
                    DevTools.Log.log("\(identifier)A new Token is allready refreshing. Will observe for a change....")
                    self.rxTokenState.subscribe(onNext: { state in
                        if state == .valid {
                            DevTools.Log.log("\(identifier)Theres a new token available!")
                            endSequecence()
                        }
                        }).disposed(by: disposeBag)
                } else {
                    DevTools.Log.log("\(identifier)Invalid token. Will refresh...")
                    self.rxTokenState.accept(.refreshing)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if Bool.random() {
                            let newToken = "some_token_[\(Date())]"
                            DevTools.Log.log("\(identifier)New Token generated!".uppercased() + " -> " + newToken)
                            self.rxTokenValue.accept(newToken)
                            self.rxTokenState.accept(.valid)
                            endSequecence()
                        } else {
                            DevTools.Log.log("\(identifier)Fail generating token!".uppercased())
                            self.rxTokenState.accept(.invalid)
                            observer(.error(NSError(domain: "error.domain.refreshing", code: 0, userInfo: nil)))
                        }
                    }
                }
            }
            return Disposables.create()
        }
        .retry(10)
    }
}
*/
