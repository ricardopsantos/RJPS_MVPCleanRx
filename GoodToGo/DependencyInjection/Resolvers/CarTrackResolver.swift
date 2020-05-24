//
//  W.CarTrackWorkers.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public class CarTrackResolver {
    private init() { }
    public static var shared = CarTrackResolver()

    public let api = AppDelegate.shared.container.resolve(AppProtocols.carTrackAPI_UseCase.self)
    public let genericBusiness = AppDelegate.shared.container.resolve(AppProtocols.carTrackGenericAppBusiness_UseCase.self)
}
