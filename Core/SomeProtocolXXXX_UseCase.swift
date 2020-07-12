//
//  UseCases.swift
//  AppCore
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
//import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain

//
// Naming convention
//

// Protocol defined @ Domain
public protocol SomeProtocolXXXX_UseCaseProtocol {
    func sayHi()
}

public class SomeProtocolXXXX_UseCase: GenericUseCase, SomeProtocolXXXX_UseCaseProtocol {

    public override init() { super.init() }

    public var generic_CacheRepositoryProtocol: SimpleCacheRepositoryProtocol!
    public var generic_LocalStorageRepository: KeyValuesStorageRepositoryProtocol!

    public func sayHi() {

    }
}
