//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
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

extension AppView {
    class UserDetais_View: GenericView {
        
        deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: UserDetais_PresenterProtocol!
        
        private let _margin: CGFloat = 25
        private let _imageSize: CGFloat = 100
        
        private lazy var _lblUserName: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self.view, style: .value)
            some.rjsALayouts.setSame(.height, as: _imgAvatar)
            some.rjsALayouts.setSame(.top, as: _imgAvatar)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right, from: _imgAvatar)
            return some
        }()
        
        private lazy var _tableView: UITableView = {
            let some = AppFactory.UIKit.tableView(baseView: self.view)
            some.delegate   = self as UITableViewDelegate
            some.dataSource = self as UITableViewDataSource
            some.rjsALayouts.setMargin(_margin, on: .top, from: _imgAvatar)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin + TopBar.defaultHeight, on: .bottom)
            UserTableViewCell.prepare(tableView: some)
            return some
        }()
        
        private lazy var _imgAvatar: UIImageView = {
            let some = AppFactory.UIKit.imageView(baseView: self.view)
            some.rjsALayouts.setSize(CGSize(width: _imageSize, height: _imageSize))
            some.rjsALayouts.setMargin(_margin, on: .top, from: _topGenericBar.view)
            some.rjsALayouts.setMargin(_margin, on: .right)
            return some
        }()
        
        private lazy var _topGenericBar: TopBar = {
            let some = AppFactory.UIKit.topBar(baseController: self)
            some.setTitle(AppMessages.details.localised)
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
                .emit(onNext: { AppLogger.log("Tapped! \($0)") })
                .disposed(by: disposeBag)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = AppConstants.UIViewControllers.genericAccessibilityIdentifier(self)
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
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            _topGenericBar.lazyLoad()
            _imgAvatar.lazyLoad()
            _lblUserName.lazyLoad()
            _tableView.lazyLoad()
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension V.UserDetais_View: UserDetais_ViewProtocol {
    func setAvatarWith(image: UIImage) {
        _imgAvatar.image = image
    }
    
    func viewDataToScreen(some: VM.UserDetais) {
        _lblUserName.text = some.user.name
        _tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension V.UserDetais_View: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableView.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier) as? UserTableViewCell else {
            AppLogger.log(appCode: .dequeueReusableCellFail)
            return UITableViewCell()
        }
        presenter.tableView.configure(cell: cell, indexPath: indexPath)
        return cell
    }
}
