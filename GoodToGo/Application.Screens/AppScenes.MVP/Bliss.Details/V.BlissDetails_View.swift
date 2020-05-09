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

extension V {
    class BlissDetails_View: GenericView {
        
        deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: BlissDetails_PresenterProtocol!
        
        // BehaviorRelay model a State
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[Bliss.ChoiceElement]>(value: [])
        private var _imgCoverConstraintHeigth: NSLayoutConstraint?
        private let _margin: CGFloat = 15
        private let _imageSize: Int = 100
        
        private lazy var _topGenericView: TopBar = {
            let some = AppFactory.UIKit.topBar(baseController: self)
            some.setTitle(AppMessages.Bliss.appName)
            some.setTitle(AppMessages.details.localised)
            some.addBackButton()
            some.rxSignal_btnDismissTapped
                .asObservable()
                .do(onNext: { _ in AppLogger.log("rxSignal_btnDismissTapped") })
                .bind(to: presenter.rxPublishRelay_dismissView)
                .disposed(by: disposeBag)
            some.rxSignal_btnBackTapped
                .asObservable()
                .do(onNext: { _ in AppLogger.log("rxSignal_btnBackTapped") })
                .bind(to: presenter.rxPublishRelay_dismissView)
                .disposed(by: disposeBag)
            some.rxSignal_viewTapped
                .do(onNext: { _ in AppLogger.log("rxSignal_viewTapped : 2") })
                .emit(onNext: { AppLogger.log("rxSignal_viewTapped : 3 \($0)") })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btnShare1: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Share in app", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth(screenWidth/2 - 2*_margin)
            some.rjsALayouts.setMargin(_margin, on: .bottom)
            some.rjsALayouts.setHeight(50)
            some.rx.tap.subscribe({ [weak self] _ in
                some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.presenter.userDidPretendToShareInApp()
                })
            })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btnShare2: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Share by Email", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth(screenWidth/2 - 2*_margin)
            some.rjsALayouts.setMargin(_margin, on: .bottom)
            some.rjsALayouts.setHeight(50)
            some.rx.tap
                .subscribe({ [weak self] _ in
                    some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                        guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                        self.presenter.userDidPretendToShareByEmail()
                    })
                })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _imgCover: UIImageView = {
            let some = AppFactory.UIKit.imageView(baseView: self.view)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .right)
            _imgCoverConstraintHeigth = some.rjsALayouts.setHeight(0, method: .constraints)
            some.rjsALayouts.setWidth(CGFloat(_imageSize))
            some.rjsALayouts.setMargin(_margin, on: .top, from: _topGenericView.view)
            some.rjsALayouts.setSame(.centerX, as: self.view)
            some.alpha = 0
            some.layer.cornerRadius = CGFloat(_imageSize) * 0.1
            some.clipsToBounds      = true
            return some
        }()
        
        private lazy var _tableView: UITableView = {
            let some = AppFactory.UIKit.tableView(baseView: self.view)
            some.backgroundColor    = .clear
            some.separatorColor     = .clear
            some.estimatedRowHeight = Sample_TableViewCell.cellSize()
            some.isScrollEnabled    = false
            some.layer.cornerRadius = 10.0
            some.clipsToBounds      = true
            some.rjsALayouts.setMargin(_margin, on: .top, from: _imgCover)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .bottom, from: _btnShare1)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx.modelSelected(Bliss.ChoiceElement.self)
                .debounce(.milliseconds(AppConstants.Rx.tappingDefaultDebounce), scheduler: MainScheduler.instance)                  .subscribe(onNext: { [weak self]  item in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    AppLogger.log("Tapped [\(item)]")
                    self.presenter.tableView.didSelect(object: item)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            _rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
                _ = element
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                cell.set(textColor: AppColors.lblTextColor)
                self.presenter.tableView.configure(cell: cell, indexPath: NSIndexPath(row: row, section: 0) as IndexPath)
            }.disposed(by: disposeBag)
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
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewDidAppear()
        }
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            _topGenericView.lazyLoad()
            _imgCover.lazyLoad()
            _btnShare1.lazyLoad()
            _btnShare2.lazyLoad()
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

extension V.BlissDetails_View: BlissDetails_ViewProtocol {
    
    func displayShareOptionsWith(text: String) {
        AppLogger.log("")
        let itens = [text]
        let activityViewController = UIActivityViewController(activityItems: itens, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func set(title: String) {
        _topGenericView.setTitle(title)
    }
    
    func viewNeedsToDisplay(list: [Bliss.ChoiceElement]) {
        _rxBehaviorRelay_tableDataSource.accept(list)
    }
    
    func set(image: UIImage) {
        let ratio = image.size.width / image.size.height
        let imgCoverCurrentWidh = screenWidth - 2 * _margin
        let newHeigth = imgCoverCurrentWidh / ratio
        _imgCover.image = image
        _imgCover.fadeTo(1)
        _imgCover.rjsALayouts.updateConstraint(_imgCoverConstraintHeigth!,
                                               toValue: newHeigth,
                                               duration: 0.3,
                                               completion: { (_) in
                                                
        })
    }
    
}
