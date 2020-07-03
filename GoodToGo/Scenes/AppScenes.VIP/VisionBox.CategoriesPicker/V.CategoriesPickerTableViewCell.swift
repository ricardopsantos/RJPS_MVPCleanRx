//
//  V.CategoriesPickerTableViewCell.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
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

protocol CategoriesPickerTableViewCellProtocol: GenericTableViewCell_Protocol {
    //var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    //var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    //func bindWith(viewModel:VM.CategoriesPicker.TableItem)
}

extension V {
    public class CategoriesPickerTableViewCell: DefaultTableViewCell {
        func configWith(viewModel: VM.CategoriesPicker.TableItem) {
            self.set(title: viewModel.subtitle)
        }
    }
}

// MARK: - TableViewCellProtocol
extension V.CategoriesPickerTableViewCell: CategoriesPickerTableViewCellProtocol {

}
