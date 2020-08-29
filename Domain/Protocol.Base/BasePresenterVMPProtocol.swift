//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

////////////////////////////////////////////
// PRESENTER PROTOCOL
// All the PRESENTERS must implement this protocol
////////////////////////////////////////////

public protocol BasePresenterVMPProtocol: AppUtilsProtocol {
    var genericView: BaseViewControllerMVPProtocol? { get }
    
    func view_deinit()
    func loadView()
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    
    func setupViewRx() // Called on loadView (ussually)
}
