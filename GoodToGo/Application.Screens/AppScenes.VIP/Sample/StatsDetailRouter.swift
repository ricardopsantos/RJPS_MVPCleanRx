//
//  StatsDetailRouter.swift
//  i9
//
//  Created by Tiago Almeida on 19/03/2019.
//  Copyright © 2019 Crédito Agrícola. All rights reserved.
//

import Foundation
import Domain

class StatsDetailRouter: NSObject, StatsDetailRoutingLogic, StatsDetailDataPassing {

    weak var viewController: StatsDetailViewController?
    var dataStore: StatsDetailDataStore?

    func routeToStatsDetail(id: String) {
        guard let fromId = dataStore?.id,
            let type = dataStore?.transactionType else {
                return
        }

        switch fromId {
        case .group:
            routeToId(id: .category(id), type: type)
        case .category:
            routeToId(id: .transactionsFromGroup(id), type: type)
        case .transactionsFromGroup:
            routeToTransactionDetail(id: id)
        }
    }

    #warning("refactor to reuse code from StatsRouter")
    private func routeToId(id: StatsDetailId, type: TransactionType) {
        let destinationVC = StatsDetailViewController.makeFromXib()
        var destinationDataSource = destinationVC.router!.dataStore!

        destinationDataSource.currentPeriod = dataStore!.currentPeriod
        destinationDataSource.id = id
        destinationDataSource.transactionType = type

        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

    #warning("refactor to reuase code from DashboardRouter")
    private func routeToTransactionDetail(id: String) {
        let destination = TimelineDetailViewController.makeFromXib()
        var destinationDS = destination.router!.dataStore!
        passIdToDetail(id: id, destination: &destinationDS)
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }

    func passIdToDetail(id: String, destination: inout TimelineDetailDataStore) {
        destination.timelineItemId = id
    }
}
