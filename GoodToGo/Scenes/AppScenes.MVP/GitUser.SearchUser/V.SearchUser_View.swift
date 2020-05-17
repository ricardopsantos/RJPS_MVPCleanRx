//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
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

public extension V {
    internal class SearchUser_View: BaseViewControllerMVP {
        
        deinit {
            if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self.className) was killed") }
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: SearchUser_PresenterProtocol!
        
        private lazy var topGenericView: TopBar = {
            let some = UIKitFactory.topBar(baseController: self, usingSafeArea: true)
            some.setTitle("Search GitHub user")
            return some
        }()
        
        private lazy var searchBar: CustomSearchBar = {
            let some = UIKitFactory.searchBar(baseView: self.view, placeholder: Messages.search.localised)
            some.rjsALayouts.setMargin(0, on: .top, from: topGenericView.view)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setHeight(50)
            some.rx.text
                .orEmpty
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.presenter.searchUserWith(username: some.text ?? "")
                })
                .disposed(by: disposeBag)
            some.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    if self.searchBar.text!.count>0 {
                        self.presenter.searchUserWith(username: some.text ?? "")
                    }
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        public override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier

            if #available(iOS 13.0, *) {
                // Always light.
                let lightView = self.view
                lightView!.overrideUserInterfaceStyle = .light
                // Always dark.
                let darkView = self.view
                darkView!.overrideUserInterfaceStyle = .dark
                // Follows the appearance of its superview.
                //let unspecifiedView = self.view
                view.overrideUserInterfaceStyle = .unspecified
                self.view = darkView
                //let isDark = traitCollection.userInterfaceStyle == .dark
            }
            
        }
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            presenter.generic?.viewDidLoad()
        }
        
        open override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
            AppLogger.error("Error")
        }
        
        open override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            presenter.generic?.viewDidAppear()
            searchBar.becomeFirstResponder()
        }
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            topGenericView.lazyLoad()
            searchBar.lazyLoad()
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }    }
}

// MARK: - View Protocol

extension V.SearchUser_View: SearchUser_ViewProtocol {
    func viewDataToScreen(some: VM.SearchUser) {
        searchBar.text = some.user
    }
}
