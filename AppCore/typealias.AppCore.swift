//
//  typealias.AppCore.swift
//  AppCore
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib
//
import DevTools
import Domain

typealias AppLogger = DevTools.AppLogger
typealias AppSimpleNetworkClient = RJS_SimpleNetworkClient

public typealias UC = UseCases
public class UseCases { private init() {} }

public typealias CarTrackUserResponseDtoElement = Domain.CarTrack.CarTrackUserResponseDtoElement
public typealias CarTrackUserModel = Domain.CarTrack.UserModel
