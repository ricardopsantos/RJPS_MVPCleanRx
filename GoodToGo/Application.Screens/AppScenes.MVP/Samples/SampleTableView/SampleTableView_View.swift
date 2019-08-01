//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RJPSLib

extension AppView {
    class SampleTableView_View: GenericView {
        
        deinit {
            AppLogs.DLog("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter : SampleTableView_PresenterProtocol!
       
        // BehaviorRelay model a State
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[E.Employee]>(value: [])

        private lazy var _tableView: UITableView = {
            let some = AppFactory.UIKit.tableView(baseView: self.view)
            some.backgroundColor = self.view.backgroundColor
            some.rjsALayouts.setMarginFromSuper(top: 0, bottom: 0, left: 0, right: 0)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx.modelSelected(E.Employee.self)
                .debounce(.milliseconds(AppConstants.Rx.tappingDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext:  { [weak self]  item in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    AppLogs.DLog("Tapped [\(item)]")
                    strongSelf.presenter.tableView.didSelect(object:some)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            some.rx
                .itemAccessoryButtonTapped
                .subscribe(onNext: { [weak self] indexPath in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    AppLogs.DLog("AccessoryButtonTapped Tapped [\(indexPath)]")
                    strongSelf.presenter.tableView.didSelectRowAt(indexPath: indexPath)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            _rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
                _ = element
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                var indexPath = NSIndexPath(row: row, section: 0)
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
            self.view.backgroundColor = .gray
            _tableView.lazyLoad()
        }
    }
}

//
// MARK: - View Protocol
//

extension V.SampleTableView_View : SampleTableView_ViewProtocol {
    func setNetworkViewVisibilityTo(_ value: Bool) {

    }
    
    func viewNeedsToDisplay(list: [E.Employee]) {
        _rxBehaviorRelay_tableDataSource.accept(list)
    }
}
