//
//  CarTrackGenericAppBusiness_UseCase.swift
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

public class CarTrackGenericAppBusinessUseCase: GenericUseCase, CarTrackGenericAppBusinessUseCaseProtocol {
    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: CacheRepositoryProtocol!
    public var generic_LocalStorageRepository: LocalStorageRepositoryProtocol!

    public func validate(user: String, password: String) {
        
    }
}
