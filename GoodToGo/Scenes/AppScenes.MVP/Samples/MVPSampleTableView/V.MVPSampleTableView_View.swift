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
import Domain

extension V {
    class MVPSampleTableView_View: BaseViewControllerMVP {
        
        deinit {
            //AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: MVPSampleTableView_PresenterProtocol!

        // BehaviorRelay model a State
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[Employee.ResponseDto]>(value: [])

        private lazy var _tableView: UITableView = {
            let some = UIKitFactory.tableView(baseView: self.view)
            some.backgroundColor = self.view.backgroundColor
            some.rjsALayouts.setMarginFromSuperview(top: 0, bottom: 0, left: 0, right: 0)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx.modelSelected(Employee.ResponseDto.self)
                .debounce(.milliseconds(AppConstants.Rx.tappingDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self]  item in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    AppLogger.log("Tapped [\(item)]")
                    self.presenter.tableView.didSelect(object: some)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            some.rx
                .itemAccessoryButtonTapped
                .subscribe(onNext: { [weak self] indexPath in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    AppLogger.log("AccessoryButtonTapped Tapped [\(indexPath)]")
                    self.presenter.tableView.didSelectRowAt(indexPath: indexPath)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            some.rx.willDisplayCell
                .subscribe(onNext: ({ (cell, _) in
                    cell.alpha = 0
                    let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                    cell.layer.transform = transform
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        cell.alpha = 1
                        cell.layer.transform = CATransform3DIdentity
                    }, completion: nil)
                })).disposed(by: disposeBag)
            
            _rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
                _ = element
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                var indexPath = NSIndexPath(row: row, section: 0)
                self.presenter.tableView.configure(cell: cell, indexPath: indexPath as IndexPath)
            }.disposed(by: disposeBag)
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
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewDidAppear()
        }

        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = .gray
            _tableView.lazyLoad()
        }

        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }

        public override func prepareLayoutByFinishingPrepareLayout() {

        }
    }
}

//
// MARK: - View Protocol
//

extension V.MVPSampleTableView_View: MVPSampleTableView_ViewProtocol {
    func setNetworkViewVisibilityTo(_ value: Bool) {

    }
    
    func viewNeedsToDisplay(list: [Employee.ResponseDto]) {
        _rxBehaviorRelay_tableDataSource.accept(list)
    }
}
