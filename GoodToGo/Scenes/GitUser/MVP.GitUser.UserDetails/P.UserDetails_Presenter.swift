//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxSwift
import RxCocoa
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Designables
import Domain

/**
 * 2 - Declare : Presenter
 */

extension Presenter {
    class UserDetails_Presenter: BasePresenterMVP {
        var generic: BasePresenterVMPProtocol?
        var genericView: BaseViewControllerMVPProtocol?
        var viewModel: VM.UserDetails? { didSet { DevTools.Log.appCode(.vmChanged); viewModelChanged() } }
        weak var view: UserDetails_ViewProtocol!
        var router: UserDetails_RouterProtocol!
        var tableView: GenericTableView_Protocol!
    }
}

/**
 * 3 - Implementation : Presenter Protocol
 */

extension P.UserDetails_Presenter: UserDetais_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        if let router = router as? BaseRouter {
            relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
            return relay
        } 
        return relay
    }
}

extension P.UserDetails_Presenter: GenericTableView_Protocol {
    func numberOfRows(_ section: Int) -> Int {
        return viewModel?.friends.count ?? 0
    }
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) {
        let user = viewModel!.friends[indexPath.row]
        cell.set(title: user.name ?? "unknown")
        downloadImage(imageURL: user.avatarUrl!, onFail: Images.notFound.image) { (image) in
            cell.set(image: image)
        }
    }
}

/**
 * 4 - Implementation : GenericPresenter_Protocol Protocol
 */

extension P.UserDetails_Presenter: BasePresenterVMPProtocol {
    func view_deinit() { }
    func loadView() { setupViewRx() }
    func viewDidAppear() { }
    func viewDidLoad() { }
    func viewWillAppear() { if viewModel != nil { updateViewWith(vm: viewModel) } }
    
    func setupViewRx() { }

}

/**
 * 5 - Presenter Private Stuff
 */

extension P.UserDetails_Presenter {
    
    private func updateViewWith(vm: VM.UserDetails?) {
        guard vm != nil else { DevTools.Log.appCode(.ignored); return }
        view.viewDataToScreen(some: vm!)
        downloadImage(imageURL: vm!.user.avatarUrl!, onFail: Images.notFound.image) { [weak self] (image) in
            self?.view.setAvatarWith(image: image!)
        }
    }
    
    func viewModelChanged() {
        updateViewWith(vm: viewModel)
    }
}
