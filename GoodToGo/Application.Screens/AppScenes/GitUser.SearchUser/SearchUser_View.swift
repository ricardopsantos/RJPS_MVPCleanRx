//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AppView {
    class SearchUser_View: GenericView {
        
        deinit {
            AppLogs.DLog("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter : SearchUser_PresenterProtocol!
        
        private lazy var _topGenericView: V.TopBar = {
            let some = AppFactory.UIKit.topBar(baseController: self)
            some.setTitle("Search GitHub user")
            return some
        }()
        
        private lazy var _searchBar: CustomSearchBar = {
            let some = AppFactory.UIKit.searchBar(baseView: self.view)
            some.rjsALayouts.setMargin(0, on: .top, from: _topGenericView.view)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setHeight(50)
            some.rx.text
                .orEmpty
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    strongSelf.presenter.searchUserWith(username: some.text ?? "")
                })
                .disposed(by: disposeBag)
            some.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (query) in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    if strongSelf._searchBar.text!.count>0  {
                        strongSelf.presenter.searchUserWith(username: some.text ?? "")
                    }
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            prepareLayout()
            presenter.generic?.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            presenter.generic?.viewDidAppear()
            _searchBar.becomeFirstResponder()
        }
        
        override func prepareLayout() {
            super.prepareLayout()
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            _topGenericView.lazyLoad()
            _searchBar.lazyLoad()
        }
        
    }
}

// MARK: - View Protocol

extension V.SearchUser_View: SearchUser_ViewProtocol {
    func viewDataToScreen(some: VM.SearchUser) {
        _searchBar.text = some.user
    }
}
