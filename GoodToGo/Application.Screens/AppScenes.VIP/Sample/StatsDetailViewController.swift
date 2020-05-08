//
//  StatsDetailViewController.swift
//  i9
//
//  Created by Marcelo Antunes on 12/26/18.
//  Copyright (c) 2018 Crédito Agrícola. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Designables
import RxSwift
import RxCocoa
import RxDataSources
import Domain

protocol StatsDetailDisplayLogic: BaseDisplayLogic {
    func displayScreen(viewModel: StatsDetail.DisplayScreen.ViewModel)
    func displayInfo(viewModel: StatsDetail.Info.ViewModel)
}

class StatsDetailViewController: BaseViewController {

    let sectionWithoutHeader = "Section"

    var interactor: StatsDetailBusinessLogic!
    var router: (NSObjectProtocol & StatsDetailRoutingLogic & StatsDetailDataPassing)!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var statsDetailHeaderView: StatsDetailHeaderView!
    private let cloudFooterView = CloudFooterView()
    private let buttonFooterView = RoundedButtonFooterView()

    typealias Section = AnimatableSectionModel<String, Stats.TableItem>
    private var seeingAll = false
    private var shouldAllowSeeAll = true
    private var shouldShowSeeAll = false
    #if DEBUG
        private let seeAllLimit = 2
    #else
        private let seeAllLimit = 5
    #endif
    private var originalTableItems = BehaviorSubject<[Section]>(value: [])
    private var tableItems = BehaviorSubject<[Section]>(value: [])

    // MARK: Setup

    override func setup() {
        let interactor = StatsDetailInteractor()
        let presenter = StatsDetailPresenter()
        let router = StatsDetailRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableFootersViews()
        fetchScreen()
        fetchInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWhite()
    }

    private func fetchScreen() {
        let request = StatsDetail.DisplayScreen.Request()
        interactor.fetchScreen(request: request)
    }

    private func fetchInfo() {
        interactor.fetchInfo()
    }

}

extension StatsDetailViewController {

    private func setupTableView() {
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.name)
        tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: TimelineTableViewCell.name)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(
            animationConfiguration: AnimationConfiguration(),
            configureCell: { _, tableView, indexPath, item in
                if item.subtitle == nil, item.percentageInfo == nil {
                    let cell = tableView.safelyDequeueReusableCell(indexPath, type: TimelineTableViewCell.self)
                    
                    cell.titleLabel.numberOfLines = 0
                    cell.setup(stat: item)
                    return cell
                }

                let cell = tableView.safelyDequeueReusableCell(indexPath, type: StatsTableViewCell.self)

                cell.configure(item)
                let categoryColor = cell.categoryColor
                cell.avatarImageView.backgroundColor = categoryColor.withAlphaComponent(0.2)
                return cell
            })

        originalTableItems
            .map { [weak self] items in
                guard let self = self else { return [] }
                guard let section = items.first else {
                    return items
                }

                if !self.shouldAllowSeeAll {
                    return items
                }

                if section.items.count <= (self.seeAllLimit) {
                    self.shouldShowSeeAll = false
                    return items
                } else if section.items.count > (self.seeAllLimit) && !self.seeingAll {
                    self.shouldShowSeeAll = true
                    return [Section(model: section.model, items: Array(section.items[..<(self.seeAllLimit)]))]
                } else {
                    self.shouldShowSeeAll = false
                    return items
                }
            }
            .subscribe(tableItems)
            .disposed(by: disposeBag)

        tableItems
            .do(onNext: { [weak self] /*sections*/ _ in
                guard let self = self else { return }
                if self.shouldShowSeeAll {
                    self.tableView.tableFooterView = self.buttonFooterView
                } else {
                    self.tableView.tableFooterView = self.cloudFooterView
                }
            })
            .subscribe()
            .disposed(by: disposeBag)

        tableItems.asObserver()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Stats.TableItem.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [router] selectedOption in
                router?.routeToStatsDetail(id: selectedOption.id)
            }).disposed(by: disposeBag)
    }

    private func setupTableFootersViews() {
        setupCloudFooterView()
        setupButtonFooterView()
    }

    private func setupCloudFooterView() {
        cloudFooterView.height = 250
        cloudFooterView.moneyImage.isHidden = false
        cloudFooterView.button.isHidden = false
    }

    private func setupButtonFooterView() {
        buttonFooterView.height = 116
        buttonFooterView.button.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.seeingAll = true
            if let items = try? self.originalTableItems.value() {
                self.originalTableItems.onNext(items)
            }
        }).disposed(by: disposeBag)
    }
}

extension StatsDetailViewController: StatsDetailDisplayLogic {

    func displayScreen(viewModel: StatsDetail.DisplayScreen.ViewModel) {
        let items: [Stats.TableItem] = []
        let sections = [Section(model: sectionWithoutHeader, items: items)]
        setupFooterStrings(lottie: viewModel.lottieAnimation, cloudTitle: viewModel.cloudTitle, seeAllButtonTitle: viewModel.seeAllButtonTitle)
        originalTableItems.onNext(sections)
    }

    func displayInfo(viewModel: StatsDetail.Info.ViewModel) {
        updateHeaderInfo(viewModel.headerInfo)
        shouldAllowSeeAll = !viewModel.showCurrentTimeInTransactionGroup
        originalTableItems.onNext(groupTransactionsByDate(viewModel.tableItems))
    }

    //REFACTOR - try to reuse some logic from DashboardPresenter
    private func groupTransactionsByDate(_ tableItems: [Stats.TableItem]) -> [Section] {
        let groupedItems = Dictionary(grouping: tableItems) { (tableItem) -> DateComponents? in
            guard let date = tableItem.date else {
                return nil
            }

            return Calendar.current.dateComponents([.day, .year, .month], from: date)
        }

        let sectionedTableItems = groupedItems.mapValues {
            return $0.sorted {
                orderByOptionalDate(date0: $0.date, date1: $1.date)
            }
        }

        let orderedDataForSections = sectionedTableItems.map { (arg) -> (Date?, [Stats.TableItem]) in
            let (key, value) = arg
            return (key != nil ? Calendar.current.date(from: key!) : nil, value)
        }.sorted {
            orderByOptionalDate(date0: $0.0, date1: $1.0)
        }

        return orderedDataForSections.map { (arg) -> Section in
            let (date, items) = arg
            return Section(model: date != nil ? date!.getWeekDayMonthFormat() : sectionWithoutHeader, items: items)
        }
    }

    private func orderByOptionalDate(date0: Date?, date1: Date?) -> Bool {
        guard let date0 = date0,
            let date1 = date1 else {
                return false
        }
        return date0 > date1
    }

}

extension StatsDetailViewController {

    private func setupFooterStrings(lottie: String, cloudTitle: String, seeAllButtonTitle: String) {
        cloudFooterView.lottieText = lottie
        cloudFooterView.labelText = cloudTitle
        cloudFooterView.button.isHidden = true
        buttonFooterView.button.setTitle(seeAllButtonTitle, for: .normal)
    }

    private func setFooterView(_ footerView: UIView, tableViewIsEmpty: Bool) {
        tableView.tableFooterView = footerView
    }

    private func updateHeaderInfo(_ headerInfo: StatsDetail.HeaderInfo) {
        statsDetailHeaderView.categoryColor = headerInfo.categoryGroupColor

        statsDetailHeaderView.avatarImageView.setup(images: headerInfo.images)
        statsDetailHeaderView.avatarImageView.backgroundColor = statsDetailHeaderView.categoryColor.withAlphaComponent(0.2)
        statsDetailHeaderView.titleLabel.text = headerInfo.title.uppercased()
        statsDetailHeaderView.subtitleLabel.text = headerInfo.subtitle

        if let category = headerInfo.category {
            statsDetailHeaderView.titleCategoryImage?.isHidden = false
            statsDetailHeaderView.titleCategoryImage.image = category.image
            statsDetailHeaderView.titleCategoryImage.tintColor = category.color
        }

        statsDetailHeaderView.transactionNameLabel.text = headerInfo.fakeCellTitle
        statsDetailHeaderView.numberLabel.text = headerInfo.fakeCellTransactionsCount
        statsDetailHeaderView.amountLabel.text = headerInfo.fakeCellAmount
        statsDetailHeaderView.percentageLabel.text = headerInfo.fakeCellPercentageString
        statsDetailHeaderView.percentage = headerInfo.fakeCellPercentageValue
    }

}

extension StatsDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = try? tableItems.value()[section],
            item.model != sectionWithoutHeader else {
            return nil
        }

        let sectionView = TitleTableSectionView(frame: .zero)
        sectionView.title = item.model
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let items = try? tableItems.value(),
            let item = items.item(at: section),
            item.model != sectionWithoutHeader else {
                return 0
        }
        return 33
    }

}

extension StatsDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = CATransitionType.fade

        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")

        if scrollView.contentOffset.y >= 120 {
            title = statsDetailHeaderView.titleLabel.text?.capitalized
        } else {
            title = nil
        }
    }

}
