//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
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
