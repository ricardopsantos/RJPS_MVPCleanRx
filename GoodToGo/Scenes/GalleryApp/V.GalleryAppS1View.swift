//
//  V.GalleryAppS1View.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
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

// MARK: - Preview

@available(iOS 13.0.0, *)
struct GalleryAppS1View_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.GalleryAppS1View, context: Context) { }
    func makeUIView(context: Context) -> V.GalleryAppS1View {
        return V.GalleryAppS1View()
    }
}

@available(iOS 13.0.0, *)
struct GalleryAppS1View_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        GalleryAppS1View_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class GalleryAppS1View: BaseGenericViewVIP {

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var scrollView: UIScrollView = {
            UIKitFactory.scrollView()
        }()

        private lazy var stackViewVLevel1: UIStackView = {
            UIKitFactory.stackView(axis: .vertical)
        }()

        private lazy var lblTitle: UILabel = {
            UIKitFactory.label(style: .value)
        }()

        private lazy var btnSample1: UIButton = {
            UIKitFactory.button(title: "btnSample1", style: .primary)
        }()

        private lazy var btnSample2: UIButton = {
            UIKitFactory.button(title: "btnSample", style: .primary)
        }()

        // Naming convention: rxTbl[MeaningfulTableName]Items
        typealias Section = AnimatableSectionModel<String, VM.GalleryAppS1.TableItem>
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
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblTitle)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample1)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(btnSample2)
            addSubview(tableView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            let defaultMargin = Designables.Sizes.Margins.defaultMargin

            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            let scrollViewHeight = screenHeight/2
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(scrollViewHeight)

            self.subViewsOf(types: [.button, .label], recursive: true).forEach { (some) in
                some.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
                some.autoLayout.marginToSuperVerticalStackView(trailing: defaultMargin, leading: defaultMargin)
            }

            #warning("Have weird autolayout issue")
            tableView.autoLayout.topToBottom(of: scrollView, offset: Designables.Sizes.Margins.defaultMargin)
            tableView.autoLayout.leadingToSuperview()
            tableView.autoLayout.trailingToSuperview()
            tableView.autoLayout.bottomToSuperview()

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            V.GalleryAppS1TableViewCell.prepare(tableView: tableView)
            tableView.estimatedRowHeight = Designables.Sizes.TableView.defaultHeightForCell
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorColor = .clear
            tableView.rx.setDelegate(self).disposed(by: disposeBag)
            lblTitle.textAlignment = .center
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
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
                        let reuseIdentifier = V.GalleryAppS1TableViewCell.reuseIdentifier
                        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                    for: IndexPath(row: row, section: section)) as? V.GalleryAppS1TableViewCell {
                            cell.configWith(viewModel: item)
                            return cell
                        }
                    case .cellType2:
                        let reuseIdentifier = V.GalleryAppS1TableViewCell.reuseIdentifier
                        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                    for: IndexPath(row: row, section: section)) as? V.GalleryAppS1TableViewCell {
                            cell.configWith(viewModel: item)
                            return cell
                        }
                    }
                    return UITableViewCell()
            })
            dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)

            rxTableItems
                .asObserver()
                .log(whereAmI())
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        public var subTitle: String {
            get { return  lblTitle.text ?? "" }
            set(newValue) {
                lblTitle.textAnimated = newValue
            }
        }

        public var titleStyleType: UILabel.LayoutStyle = .value {
            didSet {
                lblTitle.layoutStyle = titleStyleType
            }
        }

        func setupWith(someStuff viewModel: VM.GalleryAppS1.Something.ViewModel) {
            subTitle = viewModel.subTitle
            let sectionA = Section(model: viewModel.someListSectionATitle, items: viewModel.someListSectionAElements)
            let sectionB = Section(model: viewModel.someListSectionBTitle, items: viewModel.someListSectionBElements)
            rxTableItems.onNext([sectionA, sectionB])
        }

        func setupWith(screenInitialState viewModel: VM.GalleryAppS1.ScreenInitialState.ViewModel) {
            subTitle = viewModel.subTitle
            screenLayout = viewModel.screenLayout
        }

        var screenLayout: E.GalleryAppS1View.ScreenLayout = .layoutA {
            didSet {
                // show or hide stuff
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension V.GalleryAppS1View: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = DefaultTableViewSection(frame: .zero)
        if let sectionItem = try? rxTableItems.value() {
            guard sectionItem.count > section else { return nil }
            sectionView.title = sectionItem[section].model
            return sectionView
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionItem = try? rxTableItems.value() {
            let item = sectionItem[indexPath.section].items[indexPath.row]
            switch item.cellType {
            case .cellType1: return V.GalleryAppS1TableViewCell.cellSize
            case .cellType2: return V.GalleryAppS1TableViewCell.cellSize
            }
        }
        return 0
    }
}

// MARK: - Events capture

extension V.GalleryAppS1View {
    var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.GalleryAppS1.TableItem> {
        tableView.rx.modelSelected(VM.GalleryAppS1.TableItem.self)
    }
}
