//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib
import RxCocoa
import RxSwift

public protocol BlissGenericAppBusinessUseCaseProtocol: class {
    
    // PublishRelay model Events
    var rxPublishRelayApplicationDidReceivedData: PublishRelay<Void> { get }

    func setNeedToOpenScreen(screen: String, key: String, value: String)
    func screenHaveDataToHandle(screen: String) -> (String, String)?
    func screenHaveHandledData(screen: String)
    func handle(url: URL)
}
