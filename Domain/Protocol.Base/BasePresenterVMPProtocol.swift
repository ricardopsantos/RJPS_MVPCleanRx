//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

////////////////////////////////////////////
// PRESENTER PROTOCOL
// All the PRESENTERS must implement this protocol
////////////////////////////////////////////

public protocol BasePresenterVMPProtocol: AppUtils_Protocol {
    var genericView: BaseViewControllerMVPProtocol? { get }
    
    func view_deinit()
    func loadView()
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    
    func rxSetup() // Called on loadView (ussually)
}
