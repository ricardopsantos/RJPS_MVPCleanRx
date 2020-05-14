//
//  V.CartTrackMapView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

//
// INSERT INVISION/ZEPLIN RELATED LAYOUT SCREENS BELOW
//
// Colors WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/378/Colors
// Labels WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/880/Typography
// Icons WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/333/Icons
//

extension V {
    class CartTrackMapView: BaseGenericViewVIP {

        deinit {

        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var scrollView: UIScrollView = {
            UIKitFactory.scrollView()
        }()

        private lazy var stackViewVLevel1: UIStackView = {
            UIKitFactory.stackView(axis: .vertical)
        }()

        private lazy var lblSample: UILabel = {
            UIKitFactory.label(style: .value)
        }()

        private lazy var btnSample1: UIButton = {
            UIKitFactory.button(title: "btnSample1", style: .regular)
        }()

        private lazy var btnSample2: UIButton = {
            UIKitFactory.button(title: "btnSample2", style: .regular)
        }()

        private lazy var btnSample3: UIButton = {
            UIKitFactory.button(title: "btnSample3", style: .regular)
        }()

        // Naming convention: rxTbl[MeaningfulTableName]Items
        typealias Section = AnimatableSectionModel<String, VM.CartTrackMap.TableItem>
        var rxTableItems = BehaviorSubject<[Section]>(value: [])

        private lazy var tableView: UITableView = {
            UIKitFactory.tableView()
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(stackViewVLevel1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblSample)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample2)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample3)
            addSubview(tableView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            let edgesToExclude: LayoutEdge = .init([.top, .bottom])
            let defaultMargin = Designables.Sizes.Margins.defaultMargin
            let insets: TinyEdgeInsets = TinyEdgeInsets(top: defaultMargin, left: defaultMargin, bottom: defaultMargin, right: defaultMargin)
         //   lblSample.autoLayout.edgesToSuperview(excluding: edgesToExclude, insets: insets)

            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            let scrollViewHeight = screenHeight/2
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(scrollViewHeight)

            self.subViewsOf(types: [.button, .label], recursive: true).forEach { (some) in
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                some.autoLayout.marginToSuperVerticalStackView(trailing: defaultMargin, leading: defaultMargin)
            }

            #warning("Have weird autolayout issue")
/*
            2020-05-12 23:22:34.460689+0100 GoodToGo[79776:6479479] [LayoutConstraints] Unable to simultaneously satisfy constraints.
                Probably at least one of the constraints in the following list is one you don't want.
                Try this:
                    (1) look at each constraint and try to figure out which you don't expect;
                    (2) find the code that added the unwanted constraint or constraints and fix it.
            (
                "<NSLayoutConstraint:0x600001da80a0 H:|-(16)-[UILabel:0x7ffb2c512420](LTR)   (active, names: '|':UIStackView:0x7ffb2c50dfa0 )>",
                "<NSLayoutConstraint:0x600001df7b60 UIStackView:0x7ffb2c50dfa0.width == UIScrollView:0x7ffb2d021200.width   (active)>",
                "<NSLayoutConstraint:0x600001df7c00 H:|-(0)-[UIScrollView:0x7ffb2d021200](LTR)   (active, names: '|':_TtCC8GoodToGo7AppView28CartTrackMapView:0x7ffb2c508d80 )>",
                "<NSLayoutConstraint:0x600001df7c50 UIScrollView:0x7ffb2d021200.right == _TtCC8GoodToGo7AppView28CartTrackMapView:0x7ffb2c508d80.right   (active)>",
                "<NSLayoutConstraint:0x600001da8910 '_UITemporaryLayoutWidth' _TtCC8GoodToGo7AppView28CartTrackMapView:0x7ffb2c508d80.width == 0   (active)>",
                "<NSLayoutConstraint:0x600001dd7250 'UISV-alignment' UIView:0x7ffb2c50e130.trailing == UILabel:0x7ffb2c512420.trailing   (active)>",
                "<NSLayoutConstraint:0x600001dd6f80 'UISV-canvas-connection' UILayoutGuide:0x6000007e31e0'UIViewLayoutMarginsGuide'.trailing == UIView:0x7ffb2c50e130.trailing   (active)>",
                "<NSLayoutConstraint:0x600001dd6c60 'UIView-rightMargin-guide-constraint' H:[UILayoutGuide:0x6000007e31e0'UIViewLayoutMarginsGuide']-(16)-|(LTR)   (active, names: '|':UIStackView:0x7ffb2c50dfa0 )>"
            )
*/
            tableView.autoLayout.topToBottom(of: scrollView, offset: Designables.Sizes.Margins.defaultMargin)
            tableView.autoLayout.leadingToSuperview()
            tableView.autoLayout.trailingToSuperview()
            tableView.autoLayout.bottomToSuperview()

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            V.CartTrackMapTableViewCell.prepare(tableView: tableView)
            tableView.estimatedRowHeight = Designables.Sizes.TableViewCell.defaultSize
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorColor = .clear
            tableView.rx.setDelegate(self).disposed(by: disposeBag)
            lblSample.textAlignment = .center
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.appDefaultBackgroundColor
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {
            let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(
                configureCell: { _, tableView, indexPath, item in
                    let row = indexPath.row
                    let section = indexPath.section
                    switch item.cellType {
                    case .cellType1:
                        let reuseIdentifier = CartTrackMapTableViewCell.reuseIdentifier
                        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                    for: IndexPath(row: row, section: section)) as? CartTrackMapTableViewCell {
                            cell.configWith(viewModel: item)
                            return cell
                        }
                    case .cellType2:
                        let reuseIdentifier = CartTrackMapTableViewCell.reuseIdentifier
                        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                    for: IndexPath(row: row, section: section)) as? CartTrackMapTableViewCell {
                            cell.configWith(viewModel: item)
                            return cell
                        }
                    }
                    return UITableViewCell()
            })
            dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)

            rxTableItems.asObserver().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

            tableView.rx.modelSelected(VM.CartTrackMap.TableItem.self)
                .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] some in
                    guard let self = self else { return }
                    if !some.enabled { return }
                    //rxModelSelected.bind(onNext: some)
                }).disposed(by: disposeBag)
        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        public var subTitle: String {
            get { return  lblSample.text ?? "" }
            set(newValue) {
                lblSample.textAnimated = newValue
            }
        }

        public var titleStyleType: UILabel.LayoutStyle = .value {
            didSet {
                lblSample.layoutStyle = titleStyleType
            }
        }

        func setupWith(someStuff viewModel: VM.CartTrackMap.UserInfo.ViewModel) {
            /*subTitle = viewModel.subTitle
            let sectionA = Section(model: viewModel.someListSectionATitle, items: viewModel.someListSectionAElements)
            let sectionB = Section(model: viewModel.someListSectionBTitle, items: viewModel.someListSectionBElements)
            rxTableItems.onNext([sectionA, sectionB])*/
        }

        func setupWith(screenInitialState viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel) {
            //subTitle = viewModel.subTitle
            //screenLayout = viewModel.screenLayout
        }

        var screenLayout: E.CartTrackMapView.ScreenLayout = .unknown {
            didSet {
                // show or hide stuff
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension V.CartTrackMapView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        #warning("Not implemented TitleTableSectionView")
        let sectionView = TitleTableSectionView(frame: .zero)
        if let sectionItem = try? rxTableItems.value() {
            guard sectionItem.count > section else { return nil }
            sectionView.title = sectionItem[section].model
        }
        return UIView()
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Designables.Sizes.TableView.defaultHeightForHeaderInSection
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionItem = try? rxTableItems.value() {
            let item = sectionItem[indexPath.section].items[indexPath.row]
            switch item.cellType {
            case .cellType1: return V.CartTrackMapTableViewCell.cellSize
            case .cellType2: return V.CartTrackMapTableViewCell.cellSize
            }
        }
        return 0
    }
}

// MARK: - Events capture

extension V.CartTrackMapView {
    var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxBtnSample3Tap: Observable<Void> { btnSample3.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.CartTrackMap.TableItem> {
        tableView.rx.modelSelected(VM.CartTrackMap.TableItem.self)
    }
}
