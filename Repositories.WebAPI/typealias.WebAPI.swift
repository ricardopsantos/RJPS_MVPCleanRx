//
//  GoodToGo
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJSLibUFNetworking
//
import DevTools

typealias WebAPIRequestProtocol = RJS_SimpleNetworkClientRequestProtocol

public struct WebAPI {
    private init() {}
    static var useMock: Bool { return DevTools.FeatureFlag.devTeam_useMockedData.isTrue || DevTools.isMockApp }
}
