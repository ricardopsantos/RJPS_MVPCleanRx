//
//  V.LoginTableViewCell.swift
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
//import RxDataSources
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

protocol LoginTableViewCellProtocol: GenericTableViewCell_Protocol {
    //var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    //var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    //func bindWith(viewModel:VM.Login.TableItem)
}

extension V {
    class LoginTableViewCell: Sample_TableViewCell {
        func configWith(viewModel: VM.Login.TableItem) {
            self.set(title: viewModel.title)
        }
    }
}

// MARK: - TableViewCellProtocol
extension V.LoginTableViewCell: LoginTableViewCellProtocol {

}
