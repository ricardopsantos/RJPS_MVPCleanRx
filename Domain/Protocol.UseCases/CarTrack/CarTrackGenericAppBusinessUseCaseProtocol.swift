//
//  File.swift
//  Domain
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public protocol CarTrackGenericAppBusinessUseCaseProtocol: class {
    func validate(user: String, password: String)
}
