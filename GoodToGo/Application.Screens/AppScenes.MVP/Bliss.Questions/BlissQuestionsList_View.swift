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
import Swinject
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

extension AppView {
    class BlissQuestionsList_View: GenericView {
        
        deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: BlissQuestionsList_PresenterProtocol!
       
        // BehaviorRelay model a State
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[E.Bliss.QuestionElement]>(value: [])

        private let _tableViewThreshold: CGFloat = 100.0 // threshold from bottom of tableView
        private var _tableViewIsLoadingMoreData = false // flag
    
        private lazy var _topGenericView: UIBase.V.TopBar = {
            let some = AppFactory.UIKit.topBar(baseController: self)
            some.setTitle(AppMessages.Bliss.appName)
            some.rxSignal_viewTapped
                .emit(onNext: { [weak self] in
                    _ = $0
                    self?._searchBar.resignFirstResponder()
                })
                .disposed(by: disposeBag)
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
                    guard let strongSelf = self else { AppLogger.log(appCode: .referenceLost); return }
                    let query = strongSelf._searchBar.text?.trim ?? ""
                    strongSelf.presenter.userPretendDoSearchWith(filter: query)
                })
                .disposed(by: disposeBag)
            some.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (query) in
                    guard let strongSelf = self else { AppLogger.log(appCode: .referenceLost); return }
                    let query = strongSelf._searchBar.text?.trim ?? ""
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        private lazy var _tableView: UITableView = {
            let some = AppFactory.UIKit.tableView(baseView: self.view)
            some.backgroundColor = .clear
            some.separatorColor  = .clear
            some.rjsALayouts.setMargin(0, on: .top, from: _searchBar)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setMargin(0, on: .bottom)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx.setDelegate(self).disposed(by: disposeBag) // To manage heightForRowAt
            let animateCellsOnAppear = true
            if animateCellsOnAppear {
                some.rx.willDisplayCell
                .subscribe(onNext: ({ (cell, /*indexPath*/ _ ) in
                    cell.alpha = 0
                    let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                    cell.layer.transform = transform
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        cell.alpha = 1
                        cell.layer.transform = CATransform3DIdentity
                    }, completion: nil)
                })).disposed(by: disposeBag)
            }
            some.rx.modelSelected(E.Bliss.QuestionElement.self)
                .debounce(.milliseconds(AppConstants.Rx.tappingDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self]  item in
                    guard let strongSelf = self else { AppLogger.log(appCode: .referenceLost); return }
                    AppLogger.log("Tapped [\(item)]")
                    strongSelf.presenter.tableView.didSelect(object: item)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            _rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
                _ = element
                guard let strongSelf = self else { AppLogger.log(appCode: .referenceLost); return }
                var indexPath = NSIndexPath(row: row, section: 0)
                cell.set(textColor: AppColors.lblTextColor)
                strongSelf.presenter.tableView.configure(cell: cell, indexPath: indexPath as IndexPath)
                }.disposed(by: disposeBag)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            prepareLayout()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter.generic?.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewDidAppear()
        }
        
        override func prepareLayout() {
            super.prepareLayout()
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            _topGenericView.lazyLoad()
            _searchBar.lazyLoad()
            _tableView.lazyLoad()
        }
    }
}

//
// MARK: - View Protocol
//

extension V.BlissQuestionsList_View: BlissQuestionsList_ViewProtocol {
    
    func setSearch(text: String) {
        _searchBar.text = text
    }
    
    func viewNeedsToDisplay(list: [E.Bliss.QuestionElement]) {
        self._tableViewIsLoadingMoreData = false
        self._rxBehaviorRelay_tableDataSource.accept(list)
        self._searchBar.resignFirstResponder()
    }
}

//
// MARK: - UITableViewDelegate
//

extension V.BlissQuestionsList_View: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return V.Sample_TableViewCell.cellSize()
    }
}

//
// MARK: - UIScrollViewDelegate
//

extension V.BlissQuestionsList_View: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        guard !_tableViewIsLoadingMoreData else {
            // Is allready wayting for data
            return
        }
        if Double(maximumOffset) - Double(contentOffset) <= Double(_tableViewThreshold) {
            // Get more data - API call
            _searchBar.resignFirstResponder()
            self._tableViewIsLoadingMoreData = true
            presenter.viewNeedsMoreData(filter: _searchBar.text!)
        }
    }
}
