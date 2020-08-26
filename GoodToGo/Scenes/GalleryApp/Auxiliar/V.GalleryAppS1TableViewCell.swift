//
//  V.GalleryAppS1TableViewCell.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
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

protocol GalleryAppS1TableViewCellProtocol: GenericTableViewCell_Protocol {
    //var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    //var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    //func bindWith(viewModel:VM.GalleryAppS1.TableItem)
}

extension V {
    public class GalleryAppS1TableViewCell: DefaultTableViewCell {
        func configWith(viewModel: VM.GalleryAppS1.TableItem) {
            self.set(title: viewModel.subtitle)
        }
    }
}

// MARK: - TableViewCellProtocol
extension V.GalleryAppS1TableViewCell: GalleryAppS1TableViewCellProtocol {

}
