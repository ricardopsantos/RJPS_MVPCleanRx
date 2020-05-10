//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import UIKit
import RxSwift
import RJPSLib
import RxCocoa
//
import DevTools

#warning("no lugar errado")

public enum ErrorModel {
    public struct Response {
        public let title: String
        public let message: String
        public var shouldDisplay: Bool = true

        public init(title: String, message: String) {
            self.title = title
            self.message = message
        }

        public init(error: Swift.Error) {
            self.title = "Error"
            self.message = error.localizedDescription
        }
    }

    public struct ViewModel {
        public let message: String
        public init(message: String) {
            self.message = message
        }
    }
}

public enum LoadingModel {
    public struct Response {
        public let isLoading: Bool
        public let message: String

        public init(error: Error) {
            self.isLoading = false
            self.message = "\(error)"
        }

        public init(isLoading: Bool, message: String) {
            self.isLoading = isLoading
            self.message = message
        }
    }

    public struct ViewModel {
        public let isLoading: Bool
        public let message: String

        public init(isLoading: Bool, message: String = "") {
            self.isLoading = isLoading
            self.message = message
        }

        public static var isLoading: ViewModel {
            ViewModel(isLoading: true)
        }
        public static var isNotLoading: ViewModel {
            ViewModel(isLoading: false)
        }
    }
}

public protocol BaseDisplayLogicProtocol: class {
    func displayLoading(viewModel: LoadingModel.ViewModel)
    func displayError(viewModel: ErrorModel.ViewModel)
    //func displayToast(viewModel: i9.Toast.ViewModel, position: ToastPosition, completion: ((Bool) -> Void)?)
}

open class BasePresenter {
    open func baseDisplayLogicImpl() -> BaseDisplayLogicProtocol? {
        assert(false)
        return nil
    }
    deinit {
        AppLogger.log("\(self) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    public init () {}
    public var rxPublishRelay_error = PublishRelay<Error>()
    public var reachabilityService: ReachabilityService! = try! DefaultReachabilityService() // try! is only for simplicity sake
    public var disposeBag: DisposeBag = DisposeBag()
   
}
