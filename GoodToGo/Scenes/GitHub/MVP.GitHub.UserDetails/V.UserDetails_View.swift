//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
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

// MARK: - Preview

@available(iOS 13.0.0, *)
struct UserDetails_View_ViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: V.UserDetails_View, context: Context) { }
    func makeUIViewController(context: Context) -> V.UserDetails_View {
        let vc = AppDelegate.shared.container.resolve(V.UserDetails_View.self)!
        //vc.something(viewModel: dashboardVM)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct UserDetails_View_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return UserDetails_View_ViewControllerRepresentable()
    }
}

// MARK: - ViewController

extension V {
    class UserDetails_View: BaseViewControllerMVP {
        
        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: UserDetais_PresenterProtocol!
        
        private let margin: CGFloat = Designables.Sizes.Margins.defaultMargin
        private let imageSize: CGFloat = 100
        
        private lazy var lblUserName: UILabel = {
            let some = UIKitFactory.label(baseView: self.view, style: .value)
            some.rjsALayouts.setSame(.height, as: imgAvatar)
            some.rjsALayouts.setSame(.top, as: imgAvatar)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right, from: imgAvatar)
            return some
        }()
        
        private lazy var tableView: UITableView = {
            let some = UIKitFactory.tableView(baseView: self.view)
            some.delegate   = self as UITableViewDelegate
            some.dataSource = self as UITableViewDataSource
            some.rjsALayouts.setMargin(margin, on: .top, from: imgAvatar)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin + TopBar.defaultHeight(usingSafeArea: true), on: .bottom)
            V.UserTableViewCell.prepare(tableView: some)
            return some
        }()
        
        private lazy var imgAvatar: UIImageView = {
            let some = UIKitFactory.imageView(baseView: self.view)
            some.rjsALayouts.setSize(CGSize(width: imageSize, height: imageSize))
            some.rjsALayouts.setMargin(margin, on: .top, from: topGenericBar.view)
            some.rjsALayouts.setMargin(margin, on: .right)
            return some
        }()
        
        private lazy var topGenericBar: TopBar = {
            let some = UIKitFactory.topBar(baseController: self, usingSafeArea: true)
            some.setTitle(Messages.details.localised)
            some.addDismissButton()
            some.rxSignal_btnDismissTapped
                .asObservable()
                .bind(to: presenter.rxPublishRelay_dismissView)
                .disposed(by: disposeBag)
            some.rxSignal_btnBackTapped
                .asObservable()
                .bind(to: presenter.rxPublishRelay_dismissView)
                .disposed(by: disposeBag)
            some.rxSignal_viewTapped
                .emit(onNext: { DevTools.Log.message("Tapped! \($0)") })
                .disposed(by: disposeBag)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter.generic?.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
        }
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.background
            topGenericBar.lazyLoad()
            imgAvatar.lazyLoad()
            lblUserName.lazyLoad()
            tableView.lazyLoad()
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension V.UserDetails_View: UserDetails_ViewProtocol {
    func setAvatarWith(image: UIImage) {
        imgAvatar.image = image
    }
    
    func viewDataToScreen(some: VM.UserDetails) {
        lblUserName.textAnimated = some.user.name
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension V.UserDetails_View: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableView.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: V.UserTableViewCell.reuseIdentifier) as? V.UserTableViewCell else {
            DevTools.Log.appCode(.dequeueReusableCellFail)
            return UITableViewCell()
        }
        presenter.tableView.configure(cell: cell, indexPath: indexPath)
        return cell
    }
}
