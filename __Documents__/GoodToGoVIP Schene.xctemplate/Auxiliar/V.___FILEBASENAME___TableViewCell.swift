//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
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

protocol ___VARIABLE_sceneName___TableViewCellProtocol: GenericTableViewCell_Protocol {
    //var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    //var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    //func bindWith(viewModel:VM.___VARIABLE_sceneName___.TableItem)
}

extension V {
    class ___VARIABLE_sceneName___TableViewCell: Sample_TableViewCell {
        func configWith(viewModel: VM.___VARIABLE_sceneName___.TableItem) {
            self.set(title: viewModel.subtitle)
        }
    }
}

// MARK: - TableViewCellProtocol
extension V.___VARIABLE_sceneName___TableViewCell: ___VARIABLE_sceneName___TableViewCellProtocol {

}
