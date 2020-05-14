//
//  V.CartTrackMapTableViewCell.swift
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
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase

protocol CartTrackMapTableViewCellProtocol: GenericTableViewCell_Protocol {
    //var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    //var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    //func bindWith(viewModel:VM.CartTrackMap.TableItem)
}

extension V {
    class CartTrackMapTableViewCell: Sample_TableViewCell {
        func configWith(viewModel: VM.CartTrackMap.TableItem) {
            self.set(title: viewModel.subtitle)
        }
    }
}

// MARK: - TableViewCellProtocol
extension V.CartTrackMapTableViewCell: CartTrackMapTableViewCellProtocol {

}
