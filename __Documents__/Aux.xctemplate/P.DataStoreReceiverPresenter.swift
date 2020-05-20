//
//  P.DataStoreReceiverPresenter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 20/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
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
import AppResources
import UIBase

extension P {
    class DataStoreReceiverPresenter: BasePresenterVIP {
        weak var viewController: (DataStoreReceiverDisplayLogicProtocol)?
        override weak var baseViewController: BaseViewControllerVIPProtocol? {
            return viewController
        }
    }
}

extension P.DataStoreReceiverPresenter: DataStoreReceiverPresentationLogicProtocol { }
