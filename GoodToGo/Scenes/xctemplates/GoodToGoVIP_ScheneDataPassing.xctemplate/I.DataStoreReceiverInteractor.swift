//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
import TinyConstraints
//
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import PointFreeFunctions
import BaseUI
import AppResources

extension I {
    class DataStoreReceiverInteractor: BaseInteractorVIP, DataStoreReceiverDataStoreProtocol {

        var presenter: DataStoreReceiverPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelAToBeSettedByOtherRouter: SomeRandomModelA?
        var dsSomeKindOfModelBToBeSettedByOtherRouter: SomeRandomModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.DataStoreReceiverInteractor: DataStoreReceiverBusinessLogicProtocol {
    func requestScreenInitialState() {

        if let dataPassing = dsSomeKindOfModelAToBeSettedByOtherRouter { // <<-- DS Sample : Take notice
            DevTools.Log.message("data received A \(dataPassing)")
        }
        if let dataPassing = dsSomeKindOfModelBToBeSettedByOtherRouter { // <<-- DS Sample : Take notice
            DevTools.Log.message("data received B \(dataPassing)")
        }
    }
}
