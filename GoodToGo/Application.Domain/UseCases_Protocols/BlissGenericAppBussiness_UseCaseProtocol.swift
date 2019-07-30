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

protocol BlissGenericAppBussiness_UseCaseProtocol : class {
    
    // PublishRelay model Events
    var rxPublishRelayAppicationDidReceivedData : PublishRelay<Void> { get }

    func setNeedToOpenScreen(screen:String, key:String, value:String)
    func screenHaveDataToHandle(screen:String) -> (String, String)?
    func screenHaveHandledData(screen:String)
    func handle(url:URL)
}
