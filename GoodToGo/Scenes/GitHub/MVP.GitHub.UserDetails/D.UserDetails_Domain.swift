//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
//
import Domain
import Domain_GitHub
import Designables

// MARK: - Presenter

protocol UserDetais_PresenterProtocol: class {
    var generic: BasePresenterVMPProtocol? { get }           // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get }  // Mandatory in ALL Presenters
    var viewModel: VM.UserDetails? { get set }                // Mandatory in ALL Presenters
    var router: UserDetails_RouterProtocol! { get }           // Mandatory in ALL Presenters
    var tableView: GenericTableView_Protocol! { get }

    var rxPublishRelay_dismissView: PublishRelay<Void> { get }     // PublishRelay model Events

}

protocol UserDetails_ViewProtocol: class {
    func viewDataToScreen(some: VM.UserDetails)
    func setAvatarWith(image: UIImage)
}

// MARK: - Router

protocol UserDetails_RouterProtocol: class {
    func dismissView()
}

public extension VM {
    struct UserDetails {
        public let user: GitHub.UserResponseDto
        public let friends: [GitHub.UserResponseDto]
    }
}
