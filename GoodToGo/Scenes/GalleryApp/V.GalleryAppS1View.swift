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
import RJPSLib_Base
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
        let view = V.GalleryAppS1View()
        let item1 = VM.GalleryAppS1.TableItem(enabled: true, image: Images.noInternet.rawValue, title: "title", subtitle: "subtitle", id: "id")
        let item2 = VM.GalleryAppS1.TableItem(enabled: true, image: Images.noInternet.rawValue, title: "title", subtitle: "subtitle", id: "id")
        let viewModel = VM.GalleryAppS1.SearchByTag.ViewModel(dataSourceTitle: "", dataSource: [item1, item2])
        view.setupWith(searchByTag: viewModel)
        return view
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

        private lazy var searchBar: CustomSearchBar = {
            //UISearchBar()
            UIKitFactory.searchBar(placeholder: Messages.search.localised)
        }()

        private lazy var lblTitle: UILabel = {
            UIKitFactory.label(style: .value)
        }()

        private var collectionViewDataSource: [VM.GalleryAppS1.TableItem] = [] {
            didSet {
                collectionView.fadeTo(0)
                DispatchQueue.executeWithDelay(delay: RJS_Constants.defaultAnimationsTime) { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                    if self.collectionViewDataSource.count > 0 {
                        self.collectionView.fadeTo(1)
                        //if let text = self.collectionViewDataSource.first?.category.toString {
                        //    self.lblTitle.textAnimated = text
                        //}
                    }
                }
            }
        }

        // Naming convention: rxTbl[MeaningfulTableName]Items
        typealias Section = AnimatableSectionModel<String, VM.GalleryAppS1.TableItem>
        var rxTableItems = BehaviorSubject<[Section]>(value: [])
        var rxFilter = BehaviorSubject<String?>(value: nil)

        private lazy var tableView: UITableView = {
            UIKitFactory.tableView()
        }()

        private lazy var collectionView: UICollectionView = {
             let viewLayout = UICollectionViewFlowLayout()
             viewLayout.scrollDirection = .horizontal
             let some = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
             return some
         }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(stackViewVLevel1)
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(searchBar)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            stackViewVLevel1.uiUtils.safeAddArrangedSubview(lblTitle)
            stackViewVLevel1.uiUtils.addArrangedSeparator()
            addSubview(tableView)

            tableView.addSubview(collectionView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            stackViewVLevel1.uiUtils.edgeStackViewToSuperView()
            scrollView.autoLayout.edgesToSuperview(excluding: .bottom, insets: .zero)
            scrollView.autoLayout.height(screenHeight)

            searchBar.autoLayout.height(Designables.Sizes.Button.defaultSize.height)
            searchBar.autoLayout.widthToSuperview()
            searchBar.autoLayout.topToSuperview(offset: Designables.Sizes.Margins.defaultMargin, usingSafeArea: true)

            tableView.autoLayout.topToBottom(of: searchBar, offset: Designables.Sizes.Margins.defaultMargin)
            tableView.autoLayout.leadingToSuperview()
            tableView.autoLayout.trailingToSuperview()
            tableView.autoLayout.bottomToSuperview()

            collectionView.autoLayout.edgesToSuperview()

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

            collectionView.rx.setDelegate(self).disposed(by: disposeBag)
            collectionView.register(V.CustomCollectionViewCell.self, forCellWithReuseIdentifier: V.CustomCollectionViewCell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
            tableView.backgroundColor = self.backgroundColor
            searchBar.backgroundColor = self.backgroundColor
            searchBar.tintColor = self.backgroundColor
            searchBar.barTintColor = self.backgroundColor
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

            searchBar.rx.text
                .orEmpty
                .skip(1)
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .log(whereAmI())
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: disposeBag)
            searchBar.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { return }
                    guard self.searchBar.text!.count > 0 else { return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: self.disposeBag)

            let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(
                configureCell: { _, tableView, indexPath, item in
                    let row = indexPath.row
                    let section = indexPath.section
                    let reuseIdentifier = V.GalleryAppS1TableViewCell.reuseIdentifier
                     if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: IndexPath(row: row, section: section)) as? V.GalleryAppS1TableViewCell {
                         cell.configWith(viewModel: item)
                         return cell
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

        func setupWith(searchByTag viewModel: VM.GalleryAppS1.SearchByTag.ViewModel) {
            let section = Section(model: viewModel.dataSourceTitle, items: viewModel.dataSource)
            rxTableItems.onNext([section])
            collectionViewDataSource = viewModel.dataSource
        }

        func setupWith(screenInitialState viewModel: VM.GalleryAppS1.ScreenInitialState.ViewModel) {

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
        //if let sectionItem = try? rxTableItems.value() {
        //    let item = sectionItem[indexPath.section].items[indexPath.row]
        //}
        return V.GalleryAppS1TableViewCell.cellSize
    }
}

// MARK: - Events capture

extension V.GalleryAppS1View {
    var rxModelSelected: ControlEvent<VM.GalleryAppS1.TableItem> {
        tableView.rx.modelSelected(VM.GalleryAppS1.TableItem.self)
    }
}

// MARK: - UICollectionViewDataSource

extension V.GalleryAppS1View: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = V.CustomCollectionViewCell.identifier
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? V.CustomCollectionViewCell {
            cell.setup(viewModel: collectionViewDataSource[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension V.GalleryAppS1View: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: V.CustomCollectionViewCell.defaultWidth, height: V.CustomCollectionViewCell.defaultHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultMargin = Designables.Sizes.Margins.defaultMargin
        return UIEdgeInsets(top: defaultMargin, left: defaultMargin, bottom: defaultMargin, right: defaultMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Designables.Sizes.Margins.defaultMargin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Designables.Sizes.Margins.defaultMargin
    }
}
