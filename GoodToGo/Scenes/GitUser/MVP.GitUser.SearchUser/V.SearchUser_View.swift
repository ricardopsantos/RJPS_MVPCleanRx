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

// MARK: - Preview

@available(iOS 13.0.0, *)
struct SearchUser_ViewUI_ViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: V.SearchUser_View, context: Context) { }
    func makeUIViewController(context: Context) -> V.SearchUser_View {
        let vc = AppDelegate.shared.container.resolve(V.SearchUser_View.self)!
        //vc.something(viewModel: dashboardVM)
        return vc
    }
}

@available(iOS 13.0.0, *)
struct SearchUser_View_Preview: PreviewProvider {
    static var previews: some SwiftUI.View {
        return SearchUser_ViewUI_ViewControllerRepresentable()
    }
}

// MARK: - ViewController

public extension V {
    internal class SearchUser_View: BaseViewControllerMVP {
        
        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
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
                .log(whereAmI())
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.presenter.searchUserWith(username: some.text ?? "")
                })
                .disposed(by: disposeBag)
            some.rx
                .textDidEndEditing
                .log(whereAmI())
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { return }
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
        }
        
        open override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            presenter.generic?.viewDidAppear()
            searchBar.becomeFirstResponder()
        }
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.backgroundColor
            topGenericView.lazyLoad()
            searchBar.lazyLoad()
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension GoodToGo.V.SearchUser_View: SearchUser_ViewProtocol {
    func viewDataToScreen(some: GoodToGo.VM.SearchUser) {
        searchBar.text = some.user
    }
}
