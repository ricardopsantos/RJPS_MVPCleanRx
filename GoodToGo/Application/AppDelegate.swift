//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Swinject
import RJPSLib
import RxCocoa
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared : AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    // Where we have all the dependencies
    let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if CommandLine.arguments.contains(AppConstants_UITests.Misc.CommandLineArguments.deleteUserData) {
            //resetAllData = true
        }
        
        appPrepare(application: application)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            teste()
        }
        
        self.window?.rootViewController = V.TabBarController()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        AppGlobal.saveContext()
    }
}






func teste() {
    

}

func testeRefreshToken() {
    
    let webAPI = WEBAPI()
    
    webAPI.assyncRequest(param: "AA") { (result) in print(result) }
    webAPI.assyncRequest(param: "BB") { (result) in print(result) }
    webAPI.assyncRequest(param: "CC") { (result) in print(result) }

    DispatchQueue.executeWithDelay (delay:5) {
        webAPI.invalidateToken()
        webAPI.assyncRequest(param: "DD") { (result) in print(result) }
        webAPI.assyncRequest(param: "EE") { (result) in print(result) }
        webAPI.assyncRequest(param: "FF") { (result) in print(result) }
    }
}

var disposeBag : DisposeBag = DisposeBag()

class WEBAPI {
    private enum TokenState { case valid, invalid, refreshing }
    private let rxTokenState: BehaviorRelay = BehaviorRelay<TokenState>(value: .invalid)
    private let rxTokenValue: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    func invalidateToken() { print("Token invalidated...".uppercased()); rxTokenState.accept(.invalid) }
    func assyncRequest(param:String, result:@escaping(String) -> Void) {
       
        func requestThatNeedsToken(_ token:String) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { result("assyncRequestA.response.[\(param)][\(token)]") }
        }
        
        _rxObservableGetTokenRequest.subscribe(onSuccess: { _ in
            requestThatNeedsToken(self.rxTokenValue.value)
        }).disposed(by: disposeBag)
    }
    
    private var _rxObservableGetTokenRequest : Single<Void> {
        return Single<Void>.create { observer -> Disposable in
            let identifier = "# TokenRefresh: "
            let endSequecence = {
                print("\(identifier)Returned valid token.")
                observer(.success(()))
            }
            if self.rxTokenState.value == .valid {
                endSequecence()
            } else {
                if self.rxTokenState.value == .refreshing {
                    print("\(identifier)A new Token is allready refreshing. Will observe for a change....")
                    self.rxTokenState.subscribe(onNext: { state in
                        if state == .valid {
                            print("\(identifier)Theres a new token available!")
                            endSequecence()
                        }
                        }).disposed(by: disposeBag)
                } else {
                    print("\(identifier)Invalid token. Will refresh...")
                    self.rxTokenState.accept(.refreshing)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if Bool.random() {
                            let newToken = "some_token_[\(Date())]"
                            print("\(identifier)New Token generated!".uppercased() + " -> " + newToken)
                            self.rxTokenValue.accept(newToken)
                            self.rxTokenState.accept(.valid)
                            endSequecence()
                        } else {
                            print("\(identifier)Fail generating token!".uppercased())
                            self.rxTokenState.accept(.invalid)
                            observer(.error(NSError(domain:"error.domain.refreshing", code:0, userInfo:nil)))
                        }
                    }
                }
            }
            return Disposables.create()
        }
        .retry(10)
    }
}
