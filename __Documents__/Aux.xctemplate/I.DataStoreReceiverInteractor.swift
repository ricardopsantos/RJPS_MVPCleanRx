//
//  I.DataStoreReceiverInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 20/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
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

extension I {
    class DataStoreReceiverInteractor: BaseInteractorVIP, DataStoreReceiverDataStoreProtocol {

        var presenter: DataStoreReceiverPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }

        // DataStoreProtocol Protocol vars...
        var dsSomeKindOfModelA: DataStoreReceiverDataStoreModelA?
        var dsSomeKindOfModelB: DataStoreReceiverDataStoreModelB?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.DataStoreReceiverInteractor: DataStoreReceiverBusinessLogicProtocol {
    func requestScreenInitialState() {

        if let dataPassing = dsSomeKindOfModelA {
            print("data passed A \(dataPassing)")
        }
        if let dataPassing = dsSomeKindOfModelB {
            print("data passed B \(dataPassing)")
        }
    }
}
