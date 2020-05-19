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
import Domain
import Domain_Bliss

extension V {
    class BlissDetails_View: BaseViewControllerMVP {
        
        deinit {
            if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { AppLogger.log("\(self.className) was killed") }
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: BlissDetails_PresenterProtocol!
        
        // BehaviorRelay model a State
        private var rxBehaviorRelay_tableDataSource = BehaviorRelay<[Bliss.ChoiceElementResponseDto]>(value: [])
        private var imgCoverConstraintHeigth: NSLayoutConstraint?
        private let margin: CGFloat = Designables.Sizes.Margins.defaultMargin
        private let imageSize: Int = 100
        
        private lazy var topGenericView: TopBar = {
            let some = UIKitFactory.topBar(baseController: self, usingSafeArea: true)
            some.setTitle(Messages.details.localised)
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
        
        private lazy var btnShare1: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Share in app", style: .regular)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setWidth(screenWidth/2 - 2*margin)
            some.rjsALayouts.setMargin(margin, on: .bottom)
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
        
        private lazy var btnShare2: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Share by Email", style: .regular)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setWidth(screenWidth/2 - 2*margin)
            some.rjsALayouts.setMargin(margin, on: .bottom)
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
        
        private lazy var imgCover: UIImageView = {
            let some = UIKitFactory.imageView(baseView: self.view)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .right)
            imgCoverConstraintHeigth = some.rjsALayouts.setHeight(0, method: .constraints)
            some.rjsALayouts.setWidth(CGFloat(imageSize))
            some.rjsALayouts.setMargin(margin, on: .top, from: topGenericView.view)
            some.rjsALayouts.setSame(.centerX, as: self.view)
            some.alpha = 0
            some.layer.cornerRadius = CGFloat(imageSize) * 0.1
            some.clipsToBounds      = true
            return some
        }()
        
        private lazy var tableView: UITableView = {
            let some = UIKitFactory.tableView(baseView: self.view)
            some.backgroundColor    = .clear
            some.separatorColor     = .clear
            some.estimatedRowHeight = Sample_TableViewCell.cellSize
            some.isScrollEnabled    = false
            some.layer.cornerRadius = 10.0
            some.clipsToBounds      = true
            some.rjsALayouts.setMargin(margin, on: .top, from: imgCover)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .bottom, from: btnShare1)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx.modelSelected(Bliss.ChoiceElementResponseDto.self)
                .debounce(.milliseconds(AppConstants.Rx.tappingDefaultDebounce), scheduler: MainScheduler.instance)                  .subscribe(onNext: { [weak self]  item in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    AppLogger.log("Tapped [\(item)]")
                    self.presenter.tableView.didSelect(object: item)
                    if let index = some.indexPathForSelectedRow {
                        some.deselectRow(at: index, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
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
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            topGenericView.lazyLoad()
            imgCover.lazyLoad()
            btnShare1.lazyLoad()
            btnShare2.lazyLoad()
            tableView.lazyLoad()
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
        topGenericView.setTitle(title)
    }
    
    func viewNeedsToDisplay(list: [Bliss.ChoiceElementResponseDto]) {
        rxBehaviorRelay_tableDataSource.accept(list)
    }
    
    func set(image: UIImage) {
        let ratio = image.size.width / image.size.height
        let imgCoverCurrentWidh = screenWidth - 2 * margin
        let newHeigth = imgCoverCurrentWidh / ratio
        imgCover.image = image
        imgCover.fadeTo(1)
        imgCover.rjsALayouts.updateConstraint(imgCoverConstraintHeigth!,
                                               toValue: newHeigth,
                                               duration: 0.3,
                                               completion: { (_) in
                                                
        })
    }
    
}
