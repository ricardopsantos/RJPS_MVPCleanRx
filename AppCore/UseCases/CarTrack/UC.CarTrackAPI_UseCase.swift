//
//  CartTrack.swift
//  AppCore
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain

extension UC {
    public class CarTrackAPI_UseCase: GenericUseCase, CarTrackAPI_UseCaseProtocol {

        public override init() { super.init() }

        public var repositoryNetwork: CarTrack_NetWorkRepositoryProtocol!
        public var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
        public var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!

        #warning("use new cache")
        #warning("parametro a mais")
        public func getUserDetail(userName: String, canUseCache: Bool, completionHandler: @escaping CarTrackAPI_UseCaseCompletionHandler) {
            self.repositoryNetwork.userDetails(canUseCache: true) { (result) in
                switch result {
                case .success(let some) : completionHandler(Result.success(some.entity))
                case .failure(let error): completionHandler(Result.failure(error))
                }
            }
        }
    }
}
