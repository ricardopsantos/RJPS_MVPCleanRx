//
//  V.LoginView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
//import Differentiator
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
//import RxKeyboard
//import SwifterSwift
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
    class LoginView: BaseGenericViewVIP {

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
        typealias Section = AnimatableSectionModel<String, VM.Login.TableItem>
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
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblSample)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample2)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample3)
            addSubview(tableView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            let edgesToExclude: LayoutEdge = .init([.top, .bottom])
            let insets: TinyEdgeInsets = TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            lblSample.autoLayout.edgesToSuperview(excluding: edgesToExclude, insets: insets)
            self.subViewsOf(type: .button, recursive: true).forEach { (some) in
                some.autoLayout.edgesToSuperview(excluding: edgesToExclude, insets: insets)
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            }

            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            let scrollViewHeight = screenHeight/2
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(scrollViewHeight)

            tableView.autoLayout.topToBottom(of: scrollView, offset: 24)
            tableView.autoLayout.widthToSuperview()
            tableView.autoLayout.bottomToSuperview()

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            V.LoginTableViewCell.prepare(tableView: tableView)
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
                        let reuseIdentifier = LoginTableViewCell.reuseIdentifier
                        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                    for: IndexPath(row: row, section: section)) as? LoginTableViewCell {
                            cell.configWith(viewModel: item)
                            return cell
                        }
                    case .cellType2:
                        let reuseIdentifier = LoginTableViewCell.reuseIdentifier
                        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                    for: IndexPath(row: row, section: section)) as? LoginTableViewCell {
                            cell.configWith(viewModel: item)
                            return cell
                        }
                    }
                    return UITableViewCell()
            })
            dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)

            rxTableItems.asObserver().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

            tableView.rx.modelSelected(VM.Login.TableItem.self)
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

        func setupWith(someStuff viewModel: VM.Login.SomeStuff.ViewModel) {
            subTitle = viewModel.subTitle
            let sectionA = Section(model: viewModel.someListSectionATitle, items: viewModel.someListSectionAElements)
            let sectionB = Section(model: viewModel.someListSectionBTitle, items: viewModel.someListSectionBElements)
            rxTableItems.onNext([sectionA, sectionB])
        }

        func setupWith(screenInitialState viewModel: VM.Login.ScreenInitialState.ViewModel) {
            subTitle = viewModel.subTitle
            screenLayout = viewModel.screenLayout
        }

        var screenLayout: E.LoginView.ScreenLayout = .unknown {
            didSet {
                // show or hide stuff
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension V.LoginView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = TitleTableSectionView(frame: .zero)
        if let sectionItem = try? rxTableItems.value() {
            sectionView.title = sectionItem[section].model
        }
        return sectionView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Designables.Sizes.TableView.defaultHeightForHeaderInSection
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionItem = try? rxTableItems.value() {
            let item = sectionItem[indexPath.section].items[indexPath.row]
            switch item.cellType {
            case .cellType1: return V.LoginTableViewCell.cellSize
            case .cellType2: return V.LoginTableViewCell.cellSize
            }
        }
        return 0
    }
}

// MARK: - Events capture

extension V.LoginView {
    var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxBtnSample3Tap: Observable<Void> { btnSample3.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.Login.TableItem> {
        tableView.rx.modelSelected(VM.Login.TableItem.self)
    }
}
